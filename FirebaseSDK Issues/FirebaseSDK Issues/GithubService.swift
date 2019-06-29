//
//  GithubService.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 27/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - APIs
extension GithubService {
    
    func getIssues() -> Observable<[GithubIssue]> {
       return sendRequest(router: Router.getIssues)
    }
    
    func getComments(id: Int) -> Observable<[IssueComment]> {
       return sendRequest(router: Router.getComments(id))
    }
}

enum FSError: Error {
    case invalidUrl
    case emptyResponse
    case jsonParsing
}

protocol URLRequestConvertible {
    func urlRequest() throws -> URLRequest
}

final class GithubService {
    
    static let BaseURL = "https://api.github.com/repos"
    
    typealias Parmas = [String:String]
    
   
    private enum Router: URLRequestConvertible {
        
        case getIssues
        case getComments(Int)
        
        private var method: String {
            switch self {
            case .getIssues, .getComments:
                return "get"
            }
        }
        
        private var path: String {
            switch self {
            case .getIssues:
                return "/firebase/firebase-ios-sdk/issues"
            case .getComments(let id):
                return "/firebase/firebase-ios-sdk/issues/\(id)/comments"
            }
        }
        
        private var headers: Parmas? {
            return [:]
        }
        
        func urlRequest() throws -> URLRequest {
            guard let url = URL(string: GithubService.BaseURL + path) else { throw FSError.invalidUrl }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method
            urlRequest.allHTTPHeaderFields = headers
            return urlRequest
        }
    }
    
    private func sendRequest<Model: Codable>(router: URLRequestConvertible) -> Observable<[Model]> {
        return Observable.create { (observer) -> Disposable in
            var task: URLSessionDataTask!
            do {
                let request = try router.urlRequest()
                task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    guard let data = data else {
                        observer.onError(FSError.emptyResponse)
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode([Model].self, from: data)
                        observer.onNext(result)
                    } catch {
                        observer.onError(FSError.jsonParsing)
                    }
                }
                task.resume()
            } catch {
                observer.onError(error)
            }
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
}

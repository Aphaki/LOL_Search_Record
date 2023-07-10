//
//  BaseInterceptor.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/03.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        request.addValue("ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7", forHTTPHeaderField: "Accept-Language")
        request.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Accept-Charset")
        request.addValue("https://developer.riotgames.com", forHTTPHeaderField: "Origin")
        request.addValue(Constants.X_Riot_Token, forHTTPHeaderField: "X-Riot-Token")
        
        completion(.success(request))
    }
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")
        if request.retryCount < 4 {
            completion(.retryWithDelay(0.02))
        } else {
            completion(.doNotRetry)
        }
    }
}

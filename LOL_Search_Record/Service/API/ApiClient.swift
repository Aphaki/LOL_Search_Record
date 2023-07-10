//
//  ApiClient.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/03.
//

import Foundation
import Alamofire

final class ApiClient {
    static let shared = ApiClient()
    
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    
    let monitors: [EventMonitor] = [ApiLogger()]
    
    var session: Session
    
    init() {
        print("ApiClient - init()")
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
}

//
//  ApiLogger.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/03.
//

import Foundation
import Alamofire

class ApiLogger: EventMonitor {
    let queue: DispatchQueue = DispatchQueue(label: "MyLab_ApiLogger")
    
    func requestDidResume(_ request: Request) {
        print("ApiLogger - requestDidResume() - \(request)")
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        debugPrint("ApiLogger - Finished: \(response)")
    }
}

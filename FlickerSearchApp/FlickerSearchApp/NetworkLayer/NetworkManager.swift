//
//  NetworkManager.swift
//  AirtelDemoApp
//
//  Created by Priye Saurabh on 18/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import Foundation

typealias ResponseTupple = (Dictionary<String, Any>? ,NSError?, query:String?)

class  NetworkManager : NetworkManagerProtocol {
    var requestInformation: BaseRequestNetworkProtocol
    var dataTask: URLSessionDataTask?
    var jsonResponse:Dictionary<String,AnyObject>?
    
    required init(information requesInfo : BaseRequestNetworkProtocol) {
          requestInformation = requesInfo
    }
    
    func loadServerDataWithRequest(withText textVal:String?,withPageNumber num:Int,completion: @escaping (ResponseTupple) -> ()) {
        guard let urlReq = requestInformation.urlRequest(withText: textVal,withPageNum: num)  else {
            return
        }
        
        dataTask = URLSession(configuration: .default).dataTask(with: urlReq){ data, response, error in
            defer { self.dataTask = nil }
            if (error != nil) {
                if let err = error  as NSError? {
                    completion((nil, err,textVal))
                } else {
                    completion((nil, NSError(domain: "Unexpected Error Information in Response", code: -1, userInfo: nil),textVal))
                }
            } else if let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 {
                completion(self.parseJSonFromResponseData(data,textVal))
            } 
        }
        dataTask?.resume()
     }

}

extension NetworkManager {
    fileprivate func parseJSonFromResponseData(_ data: Data,_ query:String?) -> (Dictionary<String, Any>?, NSError?, String?){
        var response:Dictionary<String, Any>?
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>
            return (response, nil,query)
            
        } catch let parseError as NSError {
            return (nil, parseError,query)
        }
    }
}

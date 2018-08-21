//
//  NerworkRequest.swift
//  AirtelDemoApp
//
//  Created by Priye Saurabh on 18/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import Foundation

class NetworkRequest : BaseRequestNetworkProtocol {
    var urlPathComponent:String
    var requestType = RequestType.GET

    required  init(component : String, reqType : RequestType = RequestType.GET) {
        urlPathComponent  = component
        requestType = reqType
    }
    
    func urlRequest(withText text:String?, withPageNum num:Int) -> URLRequest?  {
        var urlValue = urlStringForRequest()
        if (text != nil) {
            urlValue = urlValue + "&text=" + text! + "&page=" + String(num)
        }
        let request = URLRequest(url: URL(string: urlStringForRequest())!)
        return request
    }
}

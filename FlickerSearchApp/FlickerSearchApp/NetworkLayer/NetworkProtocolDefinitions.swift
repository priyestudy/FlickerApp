//
//  NetworkProtocolDefinitions.swift
//  AirtelDemoApp
//
//  Created by Priye Saurabh on 18/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import Foundation

enum  RequestType : String {
    case GET = "GET"
}


protocol BaseRequestNetworkProtocol {
    init(component : String, reqType : RequestType)
    
    var basUrl : String{get}
    var requestHeader:Dictionary<String, String> {get}
    
    var urlPathComponent : String{get set}
    var requestType:RequestType{get set}
    
    func urlStringForRequest() -> String
    func urlRequest(withText:String?, withPageNum:Int) -> URLRequest?
}

extension BaseRequestNetworkProtocol {
    var requestHeader : Dictionary<String, String> {
        return ["Content-Type" : "application/json"]
    }
    var basUrl:String {
        return AppConfiguration.appBaseURL()
    }

    func urlStringForRequest() -> String {
        return AppConfiguration.appBaseURL()
    }
    
}

protocol NetworkManagerProtocol {
    var dataTask:URLSessionDataTask? {get set}
    var requestInformation:BaseRequestNetworkProtocol{get set}
    init(information : BaseRequestNetworkProtocol)
    func loadServerDataWithRequest(withText:String?,withPageNumber num:Int, completion:  @escaping (ResponseTupple) -> ())
}

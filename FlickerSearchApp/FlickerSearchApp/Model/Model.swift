//
//  Model.swift
//  AirtelDemoApp
//
//  Created by Priye Saurabh on 19/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import UIKit
import Foundation

enum DownloadState : Int {
    case  New
    case  DownloadProgress
    case  Downloaded
    case  Failed
    case  CorruptURL

}
// https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg

class Record {
    private(set) var name:String? = ""
    private(set) var url:String? = ""
    private(set) var localUrlName:String? = ""
    var state:DownloadState
    
    init(dictionary:Dictionary<String, AnyObject>) {
        if let title = dictionary["title"] as? String {
            name = title
        }
        var farmValue:String? = nil
        if let farm = dictionary["farm"] as? NSNumber {
            farmValue = farm.stringValue
        }
        var serverValue:String?
        if let farm = dictionary["server"] as? NSString {
            serverValue = farm as String
        }
        
        var identifier:String? = nil
        
        if let ide = dictionary["id"] as? NSString {
            identifier = ide as String
        }
        var secretValue:String? = nil

        if let secret = dictionary["secret"] as? NSString {
            secretValue = secret as String
        }
 
        if (farmValue != nil) && (serverValue != nil)  && (identifier != nil) && (secretValue != nil) {
            url = "https://farm" + farmValue! + ".staticflickr.com/" + serverValue! + "/" + identifier! + "_"  + secretValue! + ".jpg"
            state =  DownloadState.New
            localUrlName = identifier! + secretValue!
        } else {
            url = ""
            state =  DownloadState.CorruptURL
        }
    }
}

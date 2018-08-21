//
//  AppConfigurations.swift
//  AirtelDemoApp
//
//  Created by Priye Saurabh on 18/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import Foundation

private let BaseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=1aaf9a6d0a04bc12baef7f41e613ef92&text=happy&format=json&nojsoncallback=1&per_page=30"
class AppConfiguration {
   static func appBaseURL() -> String  {
        return BaseURL
    }
    
}


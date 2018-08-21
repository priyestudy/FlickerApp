//
//  ViewModels.swift
//  WynkDemoApp
//
//  Created by Priye Saurabh on 18/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import UIKit
import Foundation

protocol ListPageViewModelProtocol {
    var downloadManager:DownloadManager {get set}
    var networkManager:NetworkManagerProtocol {get set}
    var recordList:Array<Record>{get set}
    
    func fetchRecords(text:String?,isTextChange:Bool, completionHandeler:@escaping (Bool) -> ())
    func nuberOfRowsInSection() -> Int
    func recordAtIndex(inex:Int) -> Record
    func startDownload(for photoRecord: Record, at indexPath: IndexPath, completionHandeler:@escaping (IndexPath,Bool) -> ())
    func suspendAllOperations()
    func resumeAllOperations()
    
    func titleForRecord(record:Record) -> String
    func imageForRecord(record:Record) -> UIImage?

}


class ListPageViewModel : ListPageViewModelProtocol {

    private var  pageNum:Int = 1
    var resultInformation = [String: [Record]]()
    var recordList: Array<Record> = [Record]()
    var downloadManager:DownloadManager = DownloadManager()
    
    func fetchRecords(text:String?,isTextChange:Bool,completionHandeler handler: @escaping (Bool) -> ()) {
        if (text != nil && isTextChange) {
            if ((resultInformation[text!]) != nil) {
                recordList =  resultInformation[text!]!
                let count = recordList.count
                pageNum =  Int(count/30)
                handler(true)
                return
            }
        }
        pageNum = isTextChange ? 1 : (pageNum + 1)
        networkManager.loadServerDataWithRequest(withText: text, withPageNumber: pageNum, completion: { (data, error, query) in
            if (data != nil) {
                DispatchQueue.main.async {
                    if let myData = data!["photos"] as? Dictionary<String, Any> {
                        if let photolist = myData["photo"] as? [Dictionary<String,AnyObject>] {
                            var recordItems = [Record]()
                            for obj in photolist {
                                let record = Record(dictionary: obj)
                                if record.state != DownloadState.CorruptURL {
                                    recordItems.append(record)
                                }
                            }
                            if (isTextChange) {
                                self.recordList.removeAll()
                                self.recordList = recordItems
                            } else {
                                self.recordList.append(contentsOf: recordItems)
                            }
                            if query == text {
                                self.resultInformation[text!] = self.recordList
                            }
                            handler(true)
                        }
                    }
                }
            }
        })
    }
    
    var networkManager: NetworkManagerProtocol = NetworkManager(information: NetworkRequest(component: "", reqType: RequestType.GET))
    
    func nuberOfRowsInSection() -> Int {
        return recordList.count
    }
    func recordAtIndex(inex index: Int) -> Record {
        return recordList[index]
    }
}
extension ListPageViewModel {
    func titleForRecord(record:Record) -> String {
        return record.name!
    }
    func imageForRecord(record:Record) -> UIImage? {
        let image = ImageCacheManager.sharedManager.imageForIdentifier(identifier: record.localUrlName!)
        if image != nil {
            record.state = DownloadState.Downloaded
        }
        return ImageCacheManager.sharedManager.imageForIdentifier(identifier: record.localUrlName!)
    }
}

extension ListPageViewModel {
    func startDownload(for record: Record, at indexPath: IndexPath, completionHandeler:@escaping (IndexPath,Bool) -> ())  {
         if  (ImageCacheManager.sharedManager.imageForIdentifier(identifier: record.localUrlName!) != nil){
            return
        }
        guard downloadManager.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        let downloader = ImageDownloader(record: record)
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.downloadManager.downloadsInProgress.removeValue(forKey: indexPath)
                completionHandeler(indexPath,true)
            }
        }
        downloadManager.downloadQueue.addOperation(downloader)
    }
    
    func suspendAllOperations() {
        downloadManager.downloadQueue.isSuspended = true
    }
        
    func resumeAllOperations() {
        downloadManager.downloadQueue.isSuspended = false
    }

}


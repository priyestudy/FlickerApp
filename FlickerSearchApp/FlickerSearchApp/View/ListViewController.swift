//
//  ListViewController.swift
//  AirtelDemoApp
//
//  Created by Priye Saurabh on 18/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    fileprivate let reuseIdentifier = "FlickerRecord"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate var reloadThreshold : Int = 5


    fileprivate var previousQuery: String = ""
    fileprivate var isTextChanged : Bool = false
    fileprivate var isFirstTimeImageLoaded : Bool = false

    
    @IBOutlet weak var collectionViewObject:UICollectionView!

    @IBOutlet weak var textFieldObject:UITextField?
    @IBOutlet var bottomLayoutConstraint:NSLayoutConstraint!


    var listViewModel:ListPageViewModelProtocol = ListPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromServer(textValue: "")
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController
            .keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            bottomLayoutConstraint.constant = keyboardRectangle.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        bottomLayoutConstraint.constant = 0
    }

}

extension ListViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return listViewModel.nuberOfRowsInSection()
    }
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! RecordCollectionViewCell
        let record = listViewModel.recordAtIndex(inex: indexPath.row)
        cell.backgroundColor = UIColor.darkGray
        let image = listViewModel.imageForRecord(record: record)
        if (image != nil) {
            cell.imageViewObject.image = image
            cell.activityIndicator.stopAnimating()
        } else {
            if (record.state == DownloadState.New || record.state == DownloadState.DownloadProgress) {
                cell.activityIndicator.startAnimating()
                cell.imageViewObject.image = nil
            }
        }
        
        return cell
    }
}

extension ListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension ListViewController {
    func startOperations(for record: Record, at indexPath: IndexPath) {
        switch (record.state) {
        case .New:
            listViewModel.startDownload(for: record, at: indexPath) { (indexpath, isImageLoaded) in
                if (isImageLoaded) {
                    DispatchQueue.main.async {
                        self.collectionViewObject!.reloadItems(at: [indexPath])
                    }
                }
            }
        default:
            print("Already completed")
        }
    }
    @objc func loadImageOnScreenCell() {
        if let pathsArray = collectionViewObject?.indexPathsForVisibleItems {
            let allPendingOperations = Set(listViewModel.downloadManager.downloadsInProgress.keys)
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            for indexPath in toBeCancelled {
                if let pendingDownload = listViewModel.downloadManager.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                listViewModel.downloadManager.downloadsInProgress.removeValue(forKey: indexPath)
            }
            for indexPath in toBeStarted {
                let recordToProcess = listViewModel.recordAtIndex(inex: indexPath.row)
                startOperations(for: recordToProcess, at: indexPath)
            }
        }
    }
}

extension ListViewController : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        listViewModel.suspendAllOperations()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImageOnScreenCell()
            listViewModel.resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImageOnScreenCell()
        listViewModel.resumeAllOperations()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        isTextChanged = false
        let count = listViewModel.nuberOfRowsInSection()
        if (indexPath.row > (count - reloadThreshold)) {
            loadDataFromServer(textValue: textFieldObject?.text)
        }
    }
}


extension ListViewController : UITextFieldDelegate {
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isTextChanged = true
        isFirstTimeImageLoaded = false
        listViewModel.suspendAllOperations()
        let sel = #selector(ListViewController.loadDataFromServer)

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: sel, object: previousQuery)
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            perform(sel, with: updatedText, afterDelay: 0.25)
            previousQuery = updatedText
        }
        return true
    }
}

extension ListViewController  {
    @objc func loadDataFromServer(textValue : String?) {
        listViewModel.fetchRecords(text:textValue,isTextChange: isTextChanged, completionHandeler: { (value) in
            if (value) {
                DispatchQueue.main.async {
                    self.collectionViewObject.reloadData()
                    if (!self.isFirstTimeImageLoaded) {
                        self.isFirstTimeImageLoaded = true
                        let sel = #selector(ListViewController.loadImageOnScreenCell)
                        self.perform(sel, with: nil, afterDelay: 1.0)
                        self.loadImageOnScreenCell()
                    }
                }
            }
        })
    }
}

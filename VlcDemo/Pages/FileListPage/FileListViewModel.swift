//
//  FileListViewModel.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/06.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit

class FileListViewModel: FileListViewModelProtocol {
    
    var items: [Video] = [] {
        didSet {
            changeHandler?(.updateDataModel)
        }
    }
    
    func startSynching() {
        emit(.loaderStart)
        
        try! loadFile(ofType: Categories.self, fileName: "videos", withExtension: "txt", handler: { [weak self] (result) in
            if case let .success(data) = result, let videos = data?.categories?[0].videos {
                self?.emit(.loaderEnd)
                self?.items = videos
            } else {
                if case let .failure(errorType) = result, case let .notFoundFile(fileName) = errorType {
                    self?.emit(.loaderEnd)
                    self?.emit(.error(message: "not found file : \(fileName)"))
                }
            }
        })
    }
    
    var changeHandler: ((BaseViewModelChange) -> Void)?
    
    func emit(_ change: BaseViewModelChange) {
        changeHandler?(change)
    }
    

}

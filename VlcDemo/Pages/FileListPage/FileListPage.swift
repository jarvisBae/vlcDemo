//
//  FileListPage.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/02.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit

class FileListPage: BaseTableViewController, BaseViewControllerProtocol {
    
    fileprivate var fileListDataSourceDelegate: FileListDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupUI()
    }
    
    func bindViewModel() {
        self.viewModel = FileListViewModel()
        self.viewModel?.changeHandler = {
            [unowned self] change in
            switch change {
            case .error(let message):
                print("error : \(message)")
                break
            case .loaderEnd:
                self.removeSpinner()
                break
            case .loaderStart:
                self.showSpinner(onView: self.view)
                break
            case .updateDataModel:
                self.tableView.reloadData()
                break
            }
        }
    }
    
    func setupUI() {
        self.viewModel?.startSynching()
        
        fileListDataSourceDelegate = FileListDataSource()
            .setTableView(tableView)
            .bindViewModel(viewModel!)
            .setEmptyView(UIView()) as? FileListDataSource
        fileListDataSourceDelegate?.selectRowFor(handler: { [weak self] (result) in
            guard let weakSelf = self else {
                return
            }
            if case let .success(data) = result {
                guard let video = data else {
                    print("not found video data")
                    return
                }
                let videoPlayerPage = VideoPlayerPage.new(video: video)
                weakSelf.navigationController?.pushViewController(videoPlayerPage, animated: true)
            }
        })
        tableView.delegate = fileListDataSourceDelegate
        tableView.dataSource = fileListDataSourceDelegate
    }
}

//
//  FileListDataSource.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/04.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit

class FileListDataSource: BaseTableDataSource {
    
    typealias CompletionHandler = ((_ result: Result<Video>)->Void)
    var selectHandler: CompletionHandler!
    
    func selectRowFor(handler: @escaping CompletionHandler) {
        selectHandler = handler
    }
    
    func convertViewModel() -> FileListViewModel {
        return viewModel as! FileListViewModel
    }
}

extension FileListDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.convertViewModel().items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FileCell {
            let video = self.convertViewModel().items[indexPath.row]
            cell.video = video
            return cell
        }
        return UITableViewCell()
    }
}

extension FileListDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = self.convertViewModel().items[indexPath.row]
        selectHandler(Result<Video>.success(data: video))
    }
}

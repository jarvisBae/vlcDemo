//
//  BaseTableDataSource.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/04.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit


protocol BaseTableDataSourceDelegate {
    func setItems<T>(with datas: Array<T>)
}

class BaseTableDataSource: NSObject, BaseTableDataSourceDelegate {
    
    override init() { super.init() }

    var viewModel: BaseViewModel?
    var tableView: UITableView?
    var emptyView: UIView?
    var cellIdentifier: String?
    var cellType: UITableViewCell?
    var items: Array<Any>?
    
    func setItems<T>(with datas: Array<T>) {
        items = datas
    }
}

extension BaseTableDataSource {
    
    func setTableView(_ tableView: UITableView) -> BaseTableDataSource {
        self.tableView = tableView
        return self
    }
    
    func setEmptyView(_ view: UIView) -> BaseTableDataSource {
        self.emptyView = view
        return self
    }
    
    func registerCell<Cell: UITableViewCell>(cellIdentifier: String, cellType: Cell.Type = Cell.self) -> BaseTableDataSource {
        self.cellIdentifier = cellIdentifier
        self.tableView?.register(cellType, forCellReuseIdentifier: cellIdentifier)
        return self
    }
    
    func bindViewModel(_ viewModel: BaseViewModel) -> BaseTableDataSource {
        self.viewModel = viewModel
        return self
    }
}

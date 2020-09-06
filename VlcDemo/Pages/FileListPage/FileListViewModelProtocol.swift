//
//  FileListViewModelProtocol.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/06.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import Foundation

protocol FileListViewModelProtocol : BaseViewModel{
    var items : [Video] { get set }
}

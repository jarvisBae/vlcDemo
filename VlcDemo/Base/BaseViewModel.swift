//
//  BaseViewModel.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/03.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit

protocol BaseViewModel {
    func startSynching()
    var changeHandler: ((BaseViewModelChange) -> Void)? {get set}
    func emit(_ change: BaseViewModelChange)
}

enum BaseViewModelChange {
    case loaderStart
    case loaderEnd
    case updateDataModel
    case error(message: String)
}

extension BaseViewModel{
    var baseData :BaseData? {
        return BaseData.sharedInstance
    }
}

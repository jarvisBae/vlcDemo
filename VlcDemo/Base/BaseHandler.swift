//
//  BaseHandler.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/04.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit

//공통적으로 사용될 메서드: 변경알림,

enum Result<T> {
    case success(data: T?)
    case failure(type: ErrorType)
}

enum CRUDNotification<T> {
    case create(data: T?)
    case read(data: T?)
    case update(data: T?)
    case delete(data: T?)
}

protocol BaseHandler {
    //common
    func notificationWithHandler<T>(handler: ((_ result: CRUDNotification<T>)->Void)?)
    
    //tableview
    func loadMore()
    
    //viewcontroller
    
}

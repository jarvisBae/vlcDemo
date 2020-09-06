//
//  BaseViewController.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/06.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit

protocol BaseViewControllerProtocol {
    func bindViewModel()
    func setupUI()
}

class BaseViewController: UIViewController {

    var viewModel: BaseViewModel?
    var loading : UIView?
      
    public func showSpinner(onView : UIView) {
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = onView.center
             
        DispatchQueue.main.async {
            onView.addSubview(ai)
        }
        loading = ai
    }
    
    override public func viewDidLayoutSubviews() {
        self.loading?.center = self.view.center
    }
    
    public func removeSpinner() {
        DispatchQueue.main.async {
            self.loading?.removeFromSuperview()
            self.loading = nil
        }
    }

}

class BaseTableViewController: UITableViewController {

    var viewModel: BaseViewModel?
    var loading : UIView?
      
    public func showSpinner(onView : UIView) {
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = onView.center
             
        DispatchQueue.main.async {
            onView.addSubview(ai)
        }
        loading = ai
    }
    
    override public func viewDidLayoutSubviews() {
        self.loading?.center = self.view.center
    }
    
    public func removeSpinner() {
        DispatchQueue.main.async {
            self.loading?.removeFromSuperview()
            self.loading = nil
        }
    }

}

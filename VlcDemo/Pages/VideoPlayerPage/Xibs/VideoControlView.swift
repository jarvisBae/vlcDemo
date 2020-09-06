//
//  VideoControlView.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/05.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol VideoControlViewDelegate {
    func close()
    func playAndPause(button: UIButton)
    func forward()
    func back()
    func valueChanged(position: Float)
}

class VideoControlView: UIView {

    var disposeBag: DisposeBag?
    var delegate: VideoControlViewDelegate?
    
    @IBOutlet weak var sliderPosition: UISlider!
    @IBOutlet weak var buttonTimeDisplay: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var viewControl: UIView!
    
    var isVisible: Bool = false
    private let isRunningFirst: BehaviorRelay = BehaviorRelay(value: false)
    
    @IBAction func clickClose(_ sender: UIButton) {
        rebootTimer(sender: sender)
        delegate?.close()
    }
    @IBAction func clickPlayAndPause(_ sender: UIButton) {
        rebootTimer(sender: sender)
        delegate?.playAndPause(button: sender)
    }
    @IBAction func clickForward(_ sender: UIButton) {
        rebootTimer(sender: sender)
        delegate?.forward()
    }
    @IBAction func clickBack(_ sender: UIButton) {
        rebootTimer(sender: sender)
        delegate?.back()
    }

    @IBAction func valueChangedPosition(_ sender: UISlider) {
        rebootTimer()
        delegate?.valueChanged(position: sender.value)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "VideoControlView", bundle: nil).instantiate(withOwner: nil, options: nil) [0] as! UIView
    }
    
    private func rebootTimer(sender: UIButton?=nil) {
        if sender != nil {
            sender?.zoomIn()
        }
        isRunningFirst.accept(false)
        isRunningFirst.accept(true)
    }
    
    func fadeOut() {
        buttonClose.fadeOut()
        stackViewButtons.fadeOut()
        viewControl.fadeOut()
        
        isVisible = false
        isRunningFirst.accept(false)
    }
    
    func fadeIn() {
        buttonClose.fadeIn()
        stackViewButtons.fadeIn()
        viewControl.fadeIn()
        
        isVisible = true
        isRunningFirst.accept(true)
        if disposeBag == nil { disposeBag = DisposeBag() }
        
        isRunningFirst.asObservable()
            .flatMapLatest { isRunning in
                isRunning ? Observable<Int>
                    .interval(.seconds(5), scheduler: MainScheduler.instance) : .empty()
            }
            .subscribe(onNext: { [weak self] value in
                self?.fadeOut()
            })
            .disposed(by: disposeBag!)
    }
}

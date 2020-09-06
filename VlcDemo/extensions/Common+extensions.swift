//
//  String+extensions.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/02.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit
import SnapKit


enum ErrorType {
    case notFoundFile(fileName: String)
}

extension UIViewController {
    
    /**
     * local file 호출 -> 객체로 파싱된 결과
     * - Parameter type : codable 처리된 class, struct
     * - Parameter fileName : 파일 이름
     * - Parameter withExtension : 파일 형태 : txt, json 등등
     * - Parameter handler : 결과 핸들러
     */
    func loadFile<T:Codable>(ofType type: T.Type, fileName: String, withExtension: String, handler: @escaping (_ result: Result<T>)->Void) throws {
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: withExtension) {
                let data = try Data(contentsOf: file)
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(type, from: data) {
                    handler(Result<T>.success(data: result))
                }
            } else {
                handler(Result<T>.failure(type: ErrorType.notFoundFile(fileName: fileName)))
            }
        }
    }
}

extension BaseViewModel {
    /**
     * local file 호출 -> 객체로 파싱된 결과
     * - Parameter type : codable 처리된 class, struct
     * - Parameter fileName : 파일 이름
     * - Parameter withExtension : 파일 형태 : txt, json 등등
     * - Parameter handler : 결과 핸들러
     */
    func loadFile<T:Codable>(ofType type: T.Type, fileName: String, withExtension: String, handler: @escaping (_ result: Result<T>)->Void) throws {
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: withExtension) {
                let data = try Data(contentsOf: file)
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(type, from: data) {
                    handler(Result<T>.success(data: result))
                }
            } else {
                handler(Result<T>.failure(type: ErrorType.notFoundFile(fileName: fileName)))
            }
        }
    }
}

extension UIView {
    
    func addToWindow()  {
        let window = UIApplication.shared.windows[0]
        self.frame = window.bounds
        
        let subview = window.subviews[0]
        
        subview.addSubview(self)
        self.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension UIView {
    
    func fadeIn(_ duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     
     - parameter duration: animation duration
     */
    func zoomIn(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = .identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     
     - parameter duration: animation duration
     */
    func zoomOut(duration : TimeInterval = 0.2) {
        self.transform = .identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Zoom in any view with specified offset magnification.
     
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomInWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = .identity
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    
    /**
     Zoom out any view with specified offset magnification.
     
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomOutWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    
}

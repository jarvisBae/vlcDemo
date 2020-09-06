//
//  VIdeoPlayerPage.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/04.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit
import MobileVLCKit
import SnapKit
import RxSwift

extension VideoPlayerPage {
    /**
    * searchbar 엔터, 리스트 클릭시 접근하는 뷰컨트롤러
    * parameters: storyboard 스토리보드
    * returns: 뷰컨트롤러 반환
    */
    class func new(storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil),
        video: Video) -> VideoPlayerPage {
        let page = storyboard.instantiateViewController(withIdentifier: String(describing: VideoPlayerPage.self)) as! VideoPlayerPage
        page.video = video
        return page
    }
}


class VideoPlayerPage: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var viewBG: UIView!
    
    // MARK: - Propertys
    var video: Video?
    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer()
    
    //window : fullScreenView : playerview : controlView 순서로 배치
    var fullScreenView: UIView!
    lazy var playerView = UIView()
    lazy var imageView = UIImageView()
    var controlView: VideoControlView?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureVideo()
    }
    
    // MARK: - configure
    private func configureVideo() {
        guard let videoUrl = video?.sources?[0], let imageUrl = video?.thumb else { return }
        let url = URL(string: videoUrl)
        if url == nil {
            print("Invalid URL")
            return
        }

        let media = VLCMedia(url: url!)

        media.addOptions([
            "network-caching": 300
        ])

        mediaPlayer.media = media
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.playerView

        mediaPlayer.play()
        
        DispatchQueue.global().async { [weak self] in
            self?.getImage(from:imageUrl)
        }
    }
    
    private func configureView() {
        //create fullscreenview
        fullScreenView = UIView()
        fullScreenView.backgroundColor = .black
        fullScreenView.frame = UIScreen.screens[0].bounds

        playerView.addSubview(imageView)
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(playerView)
            make.leading.equalTo(playerView)
            make.trailing.equalTo(playerView)
            make.bottom.equalTo(playerView)
        }
        
        //playerView add to fullscreenview
        fullScreenView.addSubview(playerView)
        playerView.backgroundColor = .clear
        playerView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(fullScreenView)
            make.leading.equalTo(fullScreenView)
            make.trailing.equalTo(fullScreenView)
            make.width.equalTo(playerView.snp.height).multipliedBy(16.0 / 9.0)
        }

        //controlView add to fullscreenview
        controlView = VideoControlView.instanceFromNib() as? VideoControlView
        
        if let controlView = controlView {
            controlView.delegate = self
            self.fullScreenView.addSubview(controlView)
            controlView.snp.makeConstraints { (make) -> Void in
                make.leading.equalTo(fullScreenView)
                make.trailing.equalTo(fullScreenView)
                make.bottom.equalTo(fullScreenView.safeAreaLayoutGuide.snp.bottom)
                make.top.equalTo(fullScreenView.safeAreaLayoutGuide.snp.top)
            }
            //Add tap gesture to movieView for play/pause
            let gesture = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerPage.controlViewTapped(_:)))
            controlView.addGestureRecognizer(gesture)
        }
        
        //fullscreenview add to window
        self.fullScreenView.addToWindow()
        
        //orientation change noti
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(VideoPlayerPage.rotated),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }

    // MARK: - observer
    @objc func rotated() {
        changeAspectRatio(isPortrait: UIDevice.current.orientation.isPortrait ? true : false)
    }
    
    @objc func controlViewTapped(_ sender: UITapGestureRecognizer) {
        if self.controlView?.isVisible ?? false {
            self.controlView?.fadeOut()
        } else {
            self.controlView?.fadeIn()
        }
    }
    
    // MARK: - private functions
    private func changeAspectRatio(isPortrait: Bool) {
        if isPortrait {
            playerView.snp.removeConstraints()
            playerView.snp.makeConstraints { (make) -> Void in
                make.centerY.equalTo(fullScreenView)
                make.leading.equalTo(fullScreenView)
                make.trailing.equalTo(fullScreenView)
                make.width.equalTo(playerView.snp.height).multipliedBy(16.0 / 9.0)
            }
            mediaPlayer.drawable = playerView
        } else {
            playerView.snp.removeConstraints()
            playerView.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(fullScreenView)
                make.top.equalTo(fullScreenView)
                make.bottom.equalTo(fullScreenView)
                make.width.equalTo(playerView.snp.height).multipliedBy(16.0 / 9.0)
            }
        }
    }
    
    private func getImage(from imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
                self?.imageView.image = imageToCache
                self?.imageView.backgroundColor = nil
            }
        }.resume()
    }
}

// MARK: - VLCMediaPlayerDelegate
extension VideoPlayerPage: VLCMediaPlayerDelegate {
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if mediaPlayer.state == .playing {
            
        } else if mediaPlayer.state == .ended {
            
        } else if mediaPlayer.state == .buffering {
            
        } else if mediaPlayer.state == .opening {
            
        } else if mediaPlayer.state == .esAdded {
            if let controlView = self.controlView {
                controlView.fadeIn()
                controlView.buttonPlay.setImage(UIImage(named: "pauseIcon"), for: .normal)
            }
        } else if mediaPlayer.state == .stopped {
            
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        
        if let controlView = self.controlView {
            if let buttonTimeDisplay = controlView.buttonTimeDisplay, let remainingTime = mediaPlayer.remainingTime.stringValue, let _ = mediaPlayer.time {
                buttonTimeDisplay.setTitle(remainingTime.replacingOccurrences(of: "-", with: ""), for: .normal)
            }

            if let sliderPosition = controlView.sliderPosition {
                sliderPosition.setValue(mediaPlayer.position, animated: true)
            }
        }
    }
}

// MARK: - VideoControlerViewDelegate
extension VideoPlayerPage: VideoControlViewDelegate {
    
    func close() {
        self.controlView?.isHidden = true
        fullScreenView.isHidden = true
        mediaPlayer.pause()

        if self.navigationController?.popViewController(animated: true) == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func playAndPause(button: UIButton) {
        if mediaPlayer.isPlaying {
            mediaPlayer.pause()
            button.setImage(UIImage(named: "playIcon"), for: .normal)
        } else {
            mediaPlayer.play()
            button.setImage(UIImage(named: "pauseIcon"), for: .normal)
        }
    }
    
    func forward() {
        mediaPlayer.shortJumpForward()
    }
    
    func back() {
        mediaPlayer.shortJumpBackward()
    }
    
    func valueChanged(position: Float) {
        mediaPlayer.position = position
    }
}

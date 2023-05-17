//
//  PersonalizedVideoVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 01/12/2022.
//

import UIKit
import AVFoundation
import AVKit


class PersonalizedVideoVC: UIViewController {
    
    var playerViewController = AVPlayerViewController()
    var videoData = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setVideo()
    }
    
    func setVideo() {
        let videoURL = URL(string: videoData)!
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        self.present(playerViewController, animated: false){
            self.playerViewController.player!.play()
            self.playerViewController.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
        }


    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    //MARK:- All Method
    func playerDidFinishPlaying(note: NSNotification) {
        self.navigationController?.popViewController(animated: false)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.playerViewController.removeObserver(self, forKeyPath: #keyPath(UIViewController.view.frame))
        self.navigationController?.popViewController(animated: false)
    }

}

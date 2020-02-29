//
//  ViewController.swift
//  VideoCompressDemo
//
//  Created by William_Kuo on 2019/6/28.
//  Copyright © 2019 William_Kuo. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

class ViewController: UIViewController {
    
    private var picker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker = UIImagePickerController()
        self.picker?.delegate = self
        self.picker?.sourceType = .photoLibrary
        self.picker?.mediaTypes = ["public.movie"]
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async { [unowned self] in
                    self.present(self.picker!, animated: true)
                }
            default: break
            }
        }
        
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let video = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset else { return }
        picker.dismiss(animated: true, completion: nil)
        
        VideoCompressor.compress(video: video) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let compressedVideoUrl):
                self.showVideo(with: compressedVideoUrl)
            case .failure(let error):
                print("error -> \(error)")
            }
            
            VideoCompressor.clear()
        }

    }
}

extension ViewController {
    func showVideo(with url: URL) {
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
}


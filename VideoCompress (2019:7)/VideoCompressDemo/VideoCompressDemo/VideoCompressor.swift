//
//  VideoCompressor.swift
//  VideoCompressDemo
//
//  Created by William_Kuo on 2019/6/29.
//  Copyright © 2019 William_Kuo. All rights reserved.
//

import Foundation
import Photos

enum VideoCompressError: Error {
    case urlAssetNotFound
    case urlAssetExportSessionNotFound
    case exportDataFailed
    case videoSizeTooLarge
}

final class VideoCompressor {
    
    public static func compress(video: PHAsset, completion: @escaping(Result<URL, VideoCompressError>) -> Void) {
        let options = PHVideoRequestOptions()
        
        PHImageManager.default()
            .requestAVAsset(forVideo: video, options: options) { asset, _, _ in
                
                guard let asset = asset as? AVURLAsset else {
                    completion(.failure(VideoCompressError.urlAssetNotFound))
                    return
                }
                
                guard let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset640x480) else {
                    completion(.failure(VideoCompressError.urlAssetExportSessionNotFound))
                    return
                }
                
                logAsset(title: "Before", asset: asset)
                
                let compressedURL = getVideoUrl()
            
                session.outputURL = compressedURL
                session.outputFileType = AVFileType.mp4
                session.shouldOptimizeForNetworkUse = true
                
                session.exportAsynchronously {
                    if session.status == .completed {
                        let afterAsset = AVURLAsset(url: compressedURL)
                        self.logAsset(title: "After", asset: afterAsset)
                        
                        let size = self.getSize(of: afterAsset)
                        if size > 20.0 {
                            completion(.failure(VideoCompressError.videoSizeTooLarge))
                        } else {
                            completion(.success(compressedURL))
                        }                    }
                }
                
        }
    }
    
    public static func clear() {
        FileManager.default.clearTmpDirectory()
    }
    
}

// ----------------------------------------------------------------------------------
/// Private funcs
// MARK: - Private funcs
// ----------------------------------------------------------------------------------

extension VideoCompressor {
    
    static var MBUnit: Int {
        return 1048576
    }
    
    private static func getVideoUrl() -> URL {
        return NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MP4")
    }
    
    private static func getSize(of asset: AVURLAsset) -> Double {
        guard let videoData = try? Data(contentsOf: asset.url) else { return 0 }
        return Double(videoData.count / MBUnit)
    }
    
    private static func getVideoTrack(of asset: AVURLAsset) -> AVAssetTrack {
        let videoTracks = asset.tracks(withMediaType: .video)
        return videoTracks[0]
    }
    
    private static func logAsset(title: String, asset: AVURLAsset) {
        #if DEBUG
        let videoSize = getSize(of: asset)
        let videoTrack = getVideoTrack(of: asset)
        let bitRate = videoTrack.estimatedDataRate
        let frameRate = videoTrack.nominalFrameRate
        
        print("[\(title)] File size compression: \(videoSize)) mb")
        print("[\(title)] bitRate: \(bitRate)")
        print("[\(title)] frameRate: \(frameRate)")
        
        #endif
    }
    
}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}



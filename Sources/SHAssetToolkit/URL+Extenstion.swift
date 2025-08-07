//
//  URL+Extenstion.swift
//  SHAssetToolkit
//
//  Created by Sajjad Hajavi on 8/7/25.
//

import AVFoundation
import UIKit

extension URL {
    func generateThumbnail() async -> UIImage? {
        let video = AVURLAsset(url: self, options: [:])
        let assetImgGenerate = AVAssetImageGenerator(asset: video)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 0, timescale: 1)
        guard let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil) else {return nil}
        return UIImage(cgImage: img)
    }
}

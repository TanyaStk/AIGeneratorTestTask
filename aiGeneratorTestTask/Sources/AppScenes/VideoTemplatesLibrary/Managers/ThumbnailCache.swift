//
//  ThumbnailCache.swift
//  aiGeneratorTestTask
//

import UIKit
import AVFoundation

final class ThumbnailCache: @unchecked Sendable {
    
    static let shared = ThumbnailCache()

    private let cache: NSCache<NSString, UIImage> = {
        let c = NSCache<NSString, UIImage>()
        c.countLimit = 100
        c.totalCostLimit = 80 * 1024 * 1024
        
        return c
    }()

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }

    func store(_ image: UIImage, for url: URL) {
        let cost = Int(image.size.width * image.size.height * 4)
        cache.setObject(image, forKey: url.absoluteString as NSString, cost: cost)
    }

    func clear() {
        cache.removeAllObjects()
    }
}

extension ThumbnailCache {
    func thumbnail(for url: URL) async -> UIImage? {
        if let cached = image(for: url) { return cached }

        let asset = AVURLAsset(url: url, options: [
            AVURLAssetPreferPreciseDurationAndTimingKey: false
        ])
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 300, height: 300)
        generator.requestedTimeToleranceBefore = CMTime(seconds: 1, preferredTimescale: 1)
        generator.requestedTimeToleranceAfter  = CMTime(seconds: 1, preferredTimescale: 1)

        guard let cgImage = try? await generator.image(
            at: CMTime(seconds: 0.5, preferredTimescale: 60)
        ).image else { return nil }

        let image = UIImage(cgImage: cgImage)
        store(image, for: url)
        return image
    }
}

//
//  VideoFileManager.swift
//  aiGeneratorTestTask
//
//

import UIKit
import AVFoundation

final class VideoFileManager {
    static let shared = VideoFileManager()
    
    private let videosDir: URL
    private let thumbnailsDir: URL
    private let fm = FileManager.default
    
    private init() {
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        videosDir = docs.appendingPathComponent("Videos", isDirectory: true)
        thumbnailsDir = docs.appendingPathComponent("Thumbnails", isDirectory: true)
        
        try? fm.createDirectory(at: videosDir, withIntermediateDirectories: true)
        try? fm.createDirectory(at: thumbnailsDir, withIntermediateDirectories: true)
    }
    
    // MARK: - Video
    
    func saveVideo(with name: String? = nil, from sourceURL: URL) throws -> String {
        let fileName = (name ?? UUID().uuidString) + ".mp4"
        let filePath = videosDir.appendingPathComponent(fileName)
        
        if fm.fileExists(atPath: filePath.path()) {
            try removeItem(at: filePath)
        }
        try fm.copyItem(at: sourceURL, to: filePath)
        
        return fileName
    }
    
    func removeItem(at url: URL) throws {
        try fm.removeItem(at: url)
    }
    
    func videoURL(for fileName: String) -> URL {
        videosDir.appendingPathComponent(fileName)
    }
    
    // MARK: - Thumbnails
    
    func generateThumbnail(for videoFileName: String) async -> String? {
        let videoURL = videosDir.appendingPathComponent(videoFileName)
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 400, height: 400)
        
        let time = CMTime(seconds: 0.5, preferredTimescale: 60)
        
        return await withCheckedContinuation { continuation in
            generator.generateCGImagesAsynchronously(
                forTimes: [NSValue(time: time)]
            ) { [weak self] _, cgImage, _, result, _ in
                guard let self, let cgImage, result == .succeeded else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let image = UIImage(cgImage: cgImage)
                
                guard let data = image.jpegData(compressionQuality: 0.75) else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let fileName = UUID().uuidString + ".jpg"
                let url = self.thumbnailsDir.appendingPathComponent(fileName)
                try? data.write(to: url)
                continuation.resume(returning: fileName)
            }
        }
    }
    
    func thumbnailImage(fileName: String?) -> UIImage? {
        guard let fileName else { return nil }
        
        let url = thumbnailsDir.appendingPathComponent(fileName)
        
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        
        let name = URL(fileURLWithPath: fileName)
            .deletingPathExtension()
            .lastPathComponent
        
        return UIImage(named: name)
    }
}

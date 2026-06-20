//
//  PhotoLibraryServiceProtocol.swift
//  aiGeneratorTestTask
//
//

import Photos

protocol PhotoLibraryServiceProtocol {
    func authorizationStatus() -> PHAuthorizationStatus
    func requestAuthorization() async -> PHAuthorizationStatus
    func saveVideo(at url: URL) async throws
}

enum PhotoLibraryError: LocalizedError {
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .saveFailed:
            "Couldn't save the video. Please try again."
        }
    }
}

final class PhotoLibraryService: PhotoLibraryServiceProtocol {
    func authorizationStatus() -> PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .addOnly)
    }

    func requestAuthorization() async -> PHAuthorizationStatus {
        await PHPhotoLibrary.requestAuthorization(for: .addOnly)
    }

    func saveVideo(at url: URL) async throws {
        do {
            try await PHPhotoLibrary.shared().performChanges { @Sendable in
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }
        } catch {
            throw PhotoLibraryError.saveFailed
        }
    }
}

// MARK: - Mock

final class MockPhotoLibraryService: PhotoLibraryServiceProtocol {
    var statusToReturn: PHAuthorizationStatus = .authorized

    func authorizationStatus() -> PHAuthorizationStatus {
        statusToReturn
    }
    
    func requestAuthorization() async -> PHAuthorizationStatus {
        statusToReturn
    }
    
    func saveVideo(at url: URL) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}

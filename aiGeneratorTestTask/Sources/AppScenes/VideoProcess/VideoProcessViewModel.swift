//
//  VideoProcessViewModel.swift
//  aiGeneratorTestTask
//

import Foundation
import Combine

@MainActor
final class VideoProcessViewModel: ObservableObject {
    
    enum State: Equatable {
        case generating
        case result(Result<VideoGenerationResponse, VideoGenerationError>)
    }
    
    @Injected(\.videoGenerationService) private var networkService
    @Injected(\.videoHistoryRepository) private var historyRepository
    @Injected(\.videoFileManager) private var fileManager
    
    @Published private(set) var state: State = .generating
    @Published private(set) var retryToken = UUID()
    
    private let request: VideoGenerationRequest
    
    init(request: VideoGenerationRequest) {
        self.request = request
    }
    
    func startGeneration() async {
        do {
            var result = try await networkService.generate(request: request)
            
            guard let videoURL = result.videoURL else {
                throw VideoGenerationError.networkFailure
            }
            
            let savedURL = try await saveGeneratedVideo(sourceURL: videoURL)
            
            guard !Task.isCancelled else { return }
            
            result.videoURL = savedURL
            state = .result(.success(result))
        } catch is CancellationError {
            print("Task is Cancelled")
        } catch let error as VideoGenerationError {
            guard !Task.isCancelled else { return }
            
            state = .result(.failure(error))
        } catch {
            guard !Task.isCancelled else { return }
            
            state = .result(.failure(.unknown))
        }
    }
    
    func retry() {
        state = .generating
        retryToken = UUID()
    }
}

private extension VideoProcessViewModel {
    func saveGeneratedVideo(sourceURL: URL) async throws -> URL {
        let videoFileName = try fileManager.saveVideo(from: sourceURL)
        let thumbFileName = await fileManager.generateThumbnail(for: videoFileName)
        
        _ = try historyRepository.save(
            videoFileName: videoFileName,
            thumbnailFileName: thumbFileName
        )
        
        return fileManager.videoURL(for: videoFileName)
    }
}

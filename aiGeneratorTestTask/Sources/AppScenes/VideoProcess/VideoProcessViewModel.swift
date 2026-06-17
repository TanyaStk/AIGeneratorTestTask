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
        case result(Result<VideoGenerationResult, VideoGenerationError>)
    }
    
    @Published private(set) var state: State = .generating
    @Published private(set) var retryToken = UUID()
    
    private let request: VideoGenerationRequest
    private let service: VideoGenerationService
    
    init(request: VideoGenerationRequest,
         service: VideoGenerationService) {
        self.request = request
        self.service = service
    }
    
    func startGeneration() async {
        do {
            let result = try await service.generate(request: request)
            guard !Task.isCancelled else { return }
            
            state = .result(.success(result))
        } catch is CancellationError {
            print("Task is Cancelled")
            
            return
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

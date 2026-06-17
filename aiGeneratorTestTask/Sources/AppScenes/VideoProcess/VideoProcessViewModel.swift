import Foundation

@MainActor
final class VideoProcessViewModel: ObservableObject {

    enum State {
        case generating
        case success(VideoGenerationResult)
        case failure(VideoGenerationError)
    }

    @Published private(set) var state: State = .generating

    let request: VideoGenerationRequest
    private let service: VideoGenerationService

    init(
        request: VideoGenerationRequest,
        service: VideoGenerationService = MockVideoGenerationService()
    ) {
        self.request = request
        self.service = service
    }

    func startGeneration() async {
        state = .generating
        do {
            let result = try await service.generate(request: request)
            state = .success(result)
        } catch let error as VideoGenerationError {
            state = .failure(error)
        } catch {
            state = .failure(.unknown)
        }
    }

    func retry() {
        Task { await startGeneration() }
    }
}
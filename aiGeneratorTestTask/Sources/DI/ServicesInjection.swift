//
//  ServicesInjection.swift
//  aiGeneratorTestTask
//

import Foundation

// MARK: - InjectedValues extensions

extension InjectedValues {
    var videoHistoryRepository: VideoHistoryRepositoryProtocol {
        get { Self[VideoHistoryRepositoryKey.self] }
        set { Self[VideoHistoryRepositoryKey.self] = newValue }
    }
    
    var videoFileManager: VideoFileManager {
        get { Self[VideoFileManagerKey.self] }
        set { Self[VideoFileManagerKey.self] = newValue }
    }
    
    var videoGenerationService: VideoGenerationService {
        get { Self[VideoGenerationServiceKey.self] }
        set { Self[VideoGenerationServiceKey.self] = newValue }
    }
    
    var videoTemplateProvider: VideoTemplateProvider {
        get { Self[VideoTemplateProviderKey.self] }
        set { Self[VideoTemplateProviderKey.self] = newValue }
    }
    
    var networkService: NetworkServiceType {
        get { Self[NetworkServiceKey.self] }
        set { Self[NetworkServiceKey.self] = newValue }
    }
    
    var chatService: ChatServiceProvider {
        get { Self[ChatServiceKey.self] }
        set { Self[ChatServiceKey.self] = newValue }
    }
    
    var chatHistoryService: ChatHistoryServiceProvider {
        get { Self[ChatHistoryServiceKey.self] }
        set { Self[ChatHistoryServiceKey.self] = newValue }
    }
    
    var apphudService: ApphudServiceType {
        get { Self[ApphudServiceKey.self] }
        set { Self[ApphudServiceKey.self] = newValue }
    }
    
    var photoLibraryService: PhotoLibraryServiceProtocol {
        get { Self[PhotoLibraryServiceKey.self] }
        set { Self[PhotoLibraryServiceKey.self] = newValue }
    }
}

// MARK: - Injected values for preview

extension InjectedValues {
    static func setupForPreviews() {
        InjectedValues[\.videoHistoryRepository] = MockVideoHistoryRepository()
        InjectedValues[\.videoGenerationService] = MockVideoGenerationService(successRate: 1.0)
        InjectedValues[\.videoTemplateProvider] = MockVideoTemplateService()
        InjectedValues[\.chatService] = MockChatService()
        InjectedValues[\.photoLibraryService] = MockPhotoLibraryService()
    }
}

// MARK: - Keys

private struct VideoHistoryRepositoryKey: InjectionKey {
    static var currentValue: VideoHistoryRepositoryProtocol = VideoHistoryRepository()
}

private struct VideoFileManagerKey: InjectionKey {
    static var currentValue: VideoFileManager = VideoFileManager.shared
}

private struct VideoGenerationServiceKey: InjectionKey {
    static var currentValue: VideoGenerationService = VideoGenerationAPIService(network: InjectedValues[\.networkService])
}

private struct VideoTemplateProviderKey: InjectionKey {
    static var currentValue: VideoTemplateProvider = VideoTemplateService(network: InjectedValues[\.networkService])
}

private struct NetworkServiceKey: InjectionKey {
    static var currentValue: NetworkServiceType = NetworkService()
}

private struct ChatServiceKey: InjectionKey {
    static var currentValue: ChatServiceProvider = ChatAPIService(network: InjectedValues[\.networkService])
}

private struct ApphudServiceKey: InjectionKey {
    static var currentValue: ApphudServiceType = ApphudService()
}

private struct ChatHistoryServiceKey: InjectionKey {
    static var currentValue: ChatHistoryServiceProvider = ChatHistoryService(
        network: InjectedValues[\.networkService]
    )
}

private struct PhotoLibraryServiceKey: InjectionKey {
    static var currentValue: PhotoLibraryServiceProtocol = PhotoLibraryService()
}

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

    var chatHistoryRepository: ChatHistoryRepository {
        get { Self[ChatHistoryRepositoryKey.self] }
        set { Self[ChatHistoryRepositoryKey.self] = newValue }
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
}

// MARK: - Injected values for preview

extension InjectedValues {
    static func setupForPreviews() {
        let context = PersistenceController(inMemory: true).context
        
        InjectedValues[\.videoHistoryRepository] = MockVideoHistoryRepository()
        InjectedValues[\.chatHistoryRepository] = ChatHistoryRepository(context: context)
        InjectedValues[\.videoGenerationService] = MockVideoGenerationService(successRate: 1.0)
    }
}

// MARK: - Keys

private struct VideoHistoryRepositoryKey: InjectionKey {
    static var currentValue: VideoHistoryRepositoryProtocol = VideoHistoryRepository()
}

private struct ChatHistoryRepositoryKey: InjectionKey {
    static var currentValue: ChatHistoryRepository = ChatHistoryRepository()
}

private struct VideoFileManagerKey: InjectionKey {
    static var currentValue: VideoFileManager = VideoFileManager.shared
}

private struct VideoGenerationServiceKey: InjectionKey {
    static var currentValue: VideoGenerationService = MockVideoGenerationService()
}

private struct VideoTemplateProviderKey: InjectionKey {
    static var currentValue: VideoTemplateProvider = MockVideoTemplateService()
}

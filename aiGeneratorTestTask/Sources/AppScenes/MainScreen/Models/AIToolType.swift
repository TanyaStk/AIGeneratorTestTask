//
//  AIToolType.swift
//  aiGeneratorTestTask
//
//

enum AIToolType {
    case photoToVideo
    case rewriteText
    case summarizeText
    
    var title: String {
        switch self {
        case .photoToVideo:
            "Turn Photo\ninto Video"
        case .rewriteText:
            "Fix & Improve\nWriting"
        case .summarizeText:
            "Understand\nFaster"
        }
    }
    
    var subtitle: String {
        switch self {
        case .photoToVideo:
            "Animate • Templates"
        case .rewriteText:
            "Rewrite • Fix grammar"
        case .summarizeText:
            "Summarize • Key points"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .photoToVideo:
                .Images.Common.Icons.imageToVideo
        case .rewriteText:
                .Images.Common.Icons.magicPencil
        case .summarizeText:
                .Images.Common.Icons.letterIWithSparks
        }
    }
    
    var isFeatured: Bool {
        switch self {
        case .photoToVideo:
            true
        case .rewriteText, .summarizeText:
            false
        }
    }
    
    var footerText: String? {
        switch self {
        case .photoToVideo:
            "Ready in seconds"
        case .rewriteText, .summarizeText:
            nil
        }
    }
}

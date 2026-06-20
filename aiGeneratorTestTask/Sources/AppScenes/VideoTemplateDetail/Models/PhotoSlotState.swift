//
//  PhotoSlotState.swift
//  aiGeneratorTestTask
//
//

import UIKit

enum PhotoSlotState {
    case empty(loadAction: () -> ())
    case loading
    case filled(UIImage, deleteAction: () -> ())
}

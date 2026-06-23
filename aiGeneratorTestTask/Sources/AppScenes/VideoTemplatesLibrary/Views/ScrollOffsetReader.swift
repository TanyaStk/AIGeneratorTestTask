//
//  ScrollOffsetReader.swift
//  aiGeneratorTestTask
//

import Foundation
import SwiftUI

struct ScrollOffsetReader: UIViewRepresentable {
    
    let onChange: (CGFloat) -> Void
    
    func makeUIView(context: Context) -> ScrollObserverView {
        ScrollObserverView(onChange: onChange)
    }
    
    func updateUIView(_ uiView: ScrollObserverView, context: Context) {}
}

final class ScrollObserverView: UIView {
    
    private let onChange: (CGFloat) -> Void
    private var displayLink: CADisplayLink?
    private var lastOffset: CGFloat = .nan
    
    init(onChange: @escaping (CGFloat) -> Void) {
        self.onChange = onChange
        super.init(frame: .zero)
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            let link = CADisplayLink(target: self, selector: #selector(tick))
            link.preferredFrameRateRange = CAFrameRateRange(minimum: 30, maximum: 60)
            link.add(to: .main, forMode: .common)
            displayLink = link
        } else {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    
    @objc private func tick() {
        guard let sv = scrollView else { return }
        
        let y = sv.contentOffset.y
        
        guard y != lastOffset else { return }
        
        lastOffset = y
        onChange(y)
    }
    
    private var scrollView: UIScrollView? {
        var v: UIView? = superview
        
        while let current = v {
            if let sv = current as? UIScrollView { return sv }
            v = current.superview
        }
        return nil
    }
}

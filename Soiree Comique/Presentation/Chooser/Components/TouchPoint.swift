//
//  TouchPoint.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import SwiftUI
import UIKit

struct TouchPoint: Identifiable, Equatable {
    let id: Int
    var location: CGPoint
    var lastMovedAt: Date
}

struct MultiTouchSurface: UIViewRepresentable {

    var onTouchesChanged: ([TouchPoint]) -> Void

    func makeUIView(context: Context) -> TouchCaptureView {
        let v = TouchCaptureView()
        v.isMultipleTouchEnabled = true
        v.onTouchesChanged = onTouchesChanged
        return v
    }

    func updateUIView(_ uiView: TouchCaptureView, context: Context) {}

    final class TouchCaptureView: UIView {

        var onTouchesChanged: (([TouchPoint]) -> Void)?

        private var touchesMap: [Int: TouchPoint] = [:]

        private func emit() {
            onTouchesChanged?(Array(touchesMap.values))
        }

        private func key(for touch: UITouch) -> Int {
            // Stable during the life of the touch
            ObjectIdentifier(touch).hashValue
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            let now = Date()
            for t in touches {
                let k = key(for: t)
                let p = t.location(in: self)
                touchesMap[k] = TouchPoint(id: k, location: p, lastMovedAt: now)
            }
            emit()
        }

        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            let now = Date()
            for t in touches {
                let k = key(for: t)
                let p = t.location(in: self)
                if touchesMap[k] != nil {
                    touchesMap[k]?.location = p
                    touchesMap[k]?.lastMovedAt = now
                }
            }
            emit()
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for t in touches {
                let k = key(for: t)
                touchesMap.removeValue(forKey: k)
            }
            emit()
        }

        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            for t in touches {
                let k = key(for: t)
                touchesMap.removeValue(forKey: k)
            }
            emit()
        }
    }
}

//
//  RPeGestureRecognizer.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import UIKit

protocol RPeGestureRecognizable: AnyObject {
    var buttonIsPressed: Bool { get set }
    func touchesBegan()
    func touchesEnded()
    func touchesMoved()
}

extension RPeGestureRecognizable {
    func touchedMoved() {}
}

final class RPeGestureRecognizer: UIGestureRecognizer {
    weak var touchesDelegate: RPeGestureRecognizable?
    override var isEnabled: Bool {
        didSet {
            guard let buttonIsPressed = touchesDelegate?.buttonIsPressed  else { return }
            if !isEnabled && buttonIsPressed {
                touchesDelegate?.buttonIsPressed = false
            }
//            touchesDelegate?.buttonIsPressed = isEnabled
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        state = .began
        touchesDelegate?.touchesBegan()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        touchesDelegate?.touchesMoved()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended
        touchesDelegate?.touchesEnded()
    }
}

//
//  MapButtonView.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import UIKit
import RxSwift

#warning("Ended up being unsed while implementing custom gesture recognizer")
final class MapButtonView: UIView {
    var buttonIsPressed: Bool = false {
        didSet {
            updateOpacity(to: buttonIsPressed ? .off : .on)
        }
    }
    
    // MARK: State
    private let animationDuration: CGFloat = 0.2

    private lazy var gestureRecognizer: RPeGestureRecognizer = {
        let gesture = RPeGestureRecognizer()
        gesture.touchesDelegate = self
        gesture.delegate = self
        return gesture
    }()

    private lazy var mainButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        addSubview(button)
        return button
    }()

    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4.0
        stack.addArrangedSubview(mapImageView)
        stack.addArrangedSubview(textLabel)
        addSubview(stack)
        return stack
    }()

    private lazy var mapImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = RPeIcon.map.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        return imageView
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.text = "View on map"
        label.textColor = UIColor.white
        label.numberOfLines = 1
        return label
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.resignFirstResponder()
        addGestureRecognizer(gestureRecognizer)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    var didTap: Observable<Void> {
        mainButton.rx
            .tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .asObservable()
    }
}

private extension MapButtonView {
    func layoutUI() {
        backgroundColor = RPeColor.pink
        addCornerRadius(10.0)
        layoutContainerStack()
        layoutMainButton()
    }

    func layoutMainButton() {
        NSLayoutConstraint.activate([
            mainButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainButton.topAnchor.constraint(equalTo: topAnchor),
            mainButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func layoutContainerStack() {
        NSLayoutConstraint.activate([
            containerStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension MapButtonView: RPeGestureRecognizable {
    func touchesMoved() {
    }

    func touchesBegan() {
        buttonIsPressed = true
    }

    func touchesEnded() {
        buttonIsPressed = false
    }
}

extension MapButtonView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MapButtonView {
    enum Opacity {
        case on
        case off
    }
    
    func updateOpacity(to opacityType: Opacity) {
        let alpha: CGFloat = (opacityType == .on) ? 1.0 : 0.6
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.backgroundColor = RPeColor.pink.withAlphaComponent(alpha)
        }
    }
}

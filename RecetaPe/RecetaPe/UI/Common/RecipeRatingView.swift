//
//  RecipeRatingView.swift
//  RecetaPe
//
//  Created by Leonardo  on 12/01/23.
//

import UIKit

final class RecipeRatingView: UIView {
    // MARK: State
    private lazy var starImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = RPeIcon.star
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.systemOrange
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.numberOfLines = 1
        addSubview(label)
        return label
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        addCornerRadius(5.0)
        layoutStarImage()
        layoutRatingLabel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setup(rating: CGFloat) {
        ratingLabel.text = "\(rating)"
    }
}

private extension RecipeRatingView {
    func layoutStarImage() {
        let inset: CGFloat = 4.0
        let side: CGFloat = 12.0
        
        NSLayoutConstraint.activate([
            starImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            starImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            starImage.heightAnchor.constraint(equalToConstant: side),
            starImage.widthAnchor.constraint(equalToConstant: side)
        ])
    }
    
    func layoutRatingLabel() {
        let xInset: CGFloat = 2.0
        NSLayoutConstraint.activate([
            ratingLabel.leadingAnchor.constraint(equalTo: starImage.trailingAnchor, constant: xInset),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -xInset),
            ratingLabel.centerYAnchor.constraint(equalTo: starImage.centerYAnchor),
            ratingLabel.topAnchor.constraint(equalTo: topAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

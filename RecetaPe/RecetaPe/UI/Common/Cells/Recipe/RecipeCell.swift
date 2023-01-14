//
//  RecipeCell.swift
//  RecetaPe
//
//  Created by Leonardo  on 9/01/23.
//

import UIKit

final class RecipeCell: UICollectionViewListCell, RPeCell {
    // MARK: State
    typealias AccessId = RecipeCellAccessId
    
    static var resuseIdentifier: String = "RECIPE_CELL_IDENTIFIER"
    
    private lazy var imageService = ImageService()
    
    weak var recipe: Recipe? {
        didSet { layoutUI() }
    }

    /// # UI
    private lazy var container: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = AccessId.container
        view.backgroundColor = .clear
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        pictureImage.addSubview(view)
        return view
    }()

    /// Recipe's image.
    private lazy var pictureImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = AccessId.recipeImage
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.addCornerRadius(5.0)
        container.addSubview(imageView)
        return imageView
    }()
    private var pictureImageCancellable: RequestCancellable?
    
    private var ratingView: UIView?

    /// Recipe's details stack.
    private lazy var detailsStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.accessibilityIdentifier = AccessId.recipeDetailsStack
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.backgroundColor = .clear
        container.addSubview(stack)
        return stack
    }()
    
    /// Recipe's name label. Assuming **all** recipes must have a name with no exception.
    private lazy var name: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = AccessId.recipeTitleLabel
        label.textColor = RPeColor.black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 21.0, weight: .bold)
        label.numberOfLines = 1
        detailsStack.addArrangedSubview(label)
        return label
    }()
    
    /// Recipe's name label. Assuming **all** recipes must have a description with no exception.
    private lazy var _description: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = AccessId.recipeDescriptionLabel
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.numberOfLines = 4
        detailsStack.addArrangedSubview(label)
        return label
    }()
    
    /// # Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// # Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        pictureImage.image = nil
        pictureImageCancellable?.cancel()
        
        name.text = nil
        _description.text = nil
        ratingView?.removeFromSuperview(); ratingView = nil
    }
    
    // MARK: Methods
    /// Dynamic UI properties and/or components.
    func setup() {
        name.text = recipe?.name
        _description.text = recipe?.description
        
        setupRating(with: recipe?.rating)
        setupRecipeImage(with: recipe?.image)
    }
}

private extension RecipeCell {
    func setupRating(with rating: CGFloat?) {
        guard let rating = rating else { return }
        let ratingView = RecipeRatingView(frame: .zero)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        pictureImage.addSubview(ratingView)
        
        ratingView.setup(rating: rating)
        
        let xInset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: pictureImage.topAnchor, constant: xInset),
            ratingView.trailingAnchor.constraint(equalTo: pictureImage.trailingAnchor, constant: -xInset)
        ])
        
        self.ratingView = ratingView
    }
    
    func setupRecipeImage(with path: String?) {
        guard let path = path else { return }
        activityIndicator.startAnimating()
        pictureImageCancellable = imageService.image(path: path, completion: {
            [weak self] (image) in
            self?.recipe?.imageContent = image
            self?.pictureImage.image = image
            self?.activityIndicator.stopAnimating()
        })
    }
}

private extension RecipeCell {
    /// Static  constant UI comenponents.
    func layoutUI() {
        contentView.addCornerRadius(10.0)
        contentView.accessibilityIdentifier = AccessId.recipeCell
        layoutContainer()
        layoutPictureImage()
        layoutActivityIndicator()
        layoutDetailStack()
    }
    
    func layoutContainer() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Content-view resizes thanks to UICollectionViewListCell, without any delegate or group layout.
        let height = container.heightAnchor.constraint(equalToConstant: 100.0)
        height.priority = .defaultHigh
        height.isActive = true
    }
 
    func layoutPictureImage() {
        let inset: CGFloat = 15.0
        let side: CGFloat = 100.0
        NSLayoutConstraint.activate([
            pictureImage.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: inset),
            pictureImage.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            pictureImage.widthAnchor.constraint(equalToConstant: side),
            pictureImage.heightAnchor.constraint(equalToConstant: side)
        ])
    }
       
    func layoutActivityIndicator() {
        let side: CGFloat = 50.0
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: pictureImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: pictureImage.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: side),
            activityIndicator.widthAnchor.constraint(equalToConstant: side)
        ])
    }
        
    func layoutDetailStack() {
        let inset: CGFloat = 15.0
        NSLayoutConstraint.activate([
            detailsStack.leadingAnchor.constraint(equalTo: pictureImage.trailingAnchor, constant: inset),
            detailsStack.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        // Omg it took so long, UIStackView's default constraints add ambuity if the size of the constraint is not a Constant.
        // Setting the priority less than required fixes the conflic. Dumb UIKit.
        let leadingAnchor = detailsStack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor,
                                                                   constant: -inset)
        leadingAnchor.priority = .defaultHigh
        leadingAnchor.isActive = true
    }
}

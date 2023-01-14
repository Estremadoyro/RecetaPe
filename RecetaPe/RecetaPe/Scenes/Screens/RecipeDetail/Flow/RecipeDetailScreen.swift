//
//  RecipeDetailScreen.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import UIKit
import RxSwift
import RxCocoa

final class RecipeDetailScreen: UIViewController, Screen {
    // MARK: State
    private weak var presenter: RecipeDetailPresentable?
    private lazy var navBarConfig = RecipeDetailNavBar(self)

    private lazy var disposeBag = DisposeBag()

    /// # UI
    // MARK: Containers
    /// Main view allowing scrolling.
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.isDirectionalLockEnabled = true
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        view.addSubview(scroll)
        return scroll
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        scrollView.addSubview(view)
        return view
    }()

    // MARK: Image
    /// Recipe's cover image.
    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addCornerRadius(15.0)
        containerView.addSubview(imageView)
        return imageView
    }()

    // MARK: Description
    private lazy var descriptionStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.addArrangedSubview(descriptionHeaderLabel)
        stack.addArrangedSubview(descriptionContentLabel)
        containerView.addSubview(stack)
        return stack
    }()

    private lazy var descriptionHeaderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = RPeColor.black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.text = "Description:"
        label.numberOfLines = 1
        return label
    }()

    /// Recipe's description.
    private lazy var descriptionContentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18.0, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Map Button
    private lazy var mapButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View on map", for: .normal)
        button.setImage(RPeIcon.map, for: .normal)
        button.backgroundColor = RPeColor.pink
        button.tintColor = UIColor.white
        button.addCornerRadius(10.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        containerView.addSubview(button)
        return button
    }()
    
    // MARK: Ingredients
    /// Ingredients stack view
    private lazy var ingredientsStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.addArrangedSubview(ingredientsHeaderLabel)
        containerView.addSubview(stack)
        return stack
    }()
    
    private lazy var ingredientsHeaderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = RPeColor.black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.text = "Ingredients:"
        label.numberOfLines = 1
        return label
    }()

    // MARK: Initializers
    init(presenter: RecipeDetailPresentable) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Life Cycle
extension RecipeDetailScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
        configureScreen()
    }
}

private extension RecipeDetailScreen {
    func configureScreen() {
        view.backgroundColor = RPeColor.white
        configureNavBar()
        layoutSubViews()
    }

    func configureBindings() {
        presenter?.recipe
            .drive(onNext: { [weak self] (recipe) in
                guard let self = self else { return }
                self.navBarConfig.configureTitle(with: recipe.name)
                self.coverImage.image = recipe.imageContent
                self.descriptionContentLabel.text = recipe.description
                self.configureIngredients(with: recipe.ingredients)
            }).disposed(by: disposeBag)
        
        guard let recipeObservable = presenter?.recipe.asObservable() else { return }
        mapButton.rx.tap.withLatestFrom(recipeObservable)
            .asDriver(onErrorJustReturn: Recipe())
            .drive(onNext: { [weak self] (recipe) in
                guard let self = self else { return }
                self.presenter?.openMap(with: recipe)
            }).disposed(by: disposeBag)
    }
}

// MARK: NavBar
private extension RecipeDetailScreen {
    func configureNavBar() {
        configureRightItems()
    }

    func configureRightItems() {
        navBarConfig.configureRightItems()
    }
}

// MARK: Subviews UI
private extension RecipeDetailScreen {
    func layoutSubViews() {
        layoutContainers()
        layoutCoverImage()
        layoutDescriptionStack()
        layoutMapButton()
        layoutIngredientsStack()
    }
    
    func layoutContainers() {
        layoutScrollView()
        layoutContainerView()
    }

    /// # Containers
    func layoutScrollView() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func layoutContainerView() {
        let xInset: CGFloat = 15.0
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: xInset),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -xInset),
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            // Hard set the max. width of the scrollview's container
            containerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -xInset * 2),
        ])
        
        // Scroll view will be vertical so the height constraint will have a lower priority.
        let heightConstraint = containerView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
    }

    /// # Cover Image
    func layoutCoverImage() {
        let aspect: CGFloat = 9 / 16
        NSLayoutConstraint.activate([
            coverImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coverImage.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor, multiplier: aspect)
        ])
    }

    /// # Description
    func layoutDescriptionStack() {
        let yInset: CGFloat = 15.0
        NSLayoutConstraint.activate([
            descriptionStack.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: yInset),
            descriptionStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            descriptionStack.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor)
        ])
    }
    
    /// # Map Button
    func layoutMapButton() {
        let height: CGFloat = 50.0
        let yInset: CGFloat = 15.0
        
        NSLayoutConstraint.activate([
            mapButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mapButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mapButton.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor, constant: yInset),
            mapButton.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    /// # Ingredients
    func layoutIngredientsStack() {
        let yInset: CGFloat = 15.0
        NSLayoutConstraint.activate([
            ingredientsStack.topAnchor.constraint(equalTo: mapButton.bottomAnchor, constant: yInset),
            ingredientsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            ingredientsStack.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor),
            ingredientsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}

private extension RecipeDetailScreen {
    func configureIngredients(with ingredients: [String]) {
        ingredients.forEach { ingredient in
            let ingredientLabel = getIngredientLabel()
            ingredientLabel.text = "⇢ \(ingredient)"
            ingredientsStack.addArrangedSubview(ingredientLabel)
            ingredientsStack.setCustomSpacing(4.0, after: ingredientLabel)
        }
    }
    
    func getIngredientLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18.0, weight: .regular)
        label.numberOfLines = 1
        return label
    }
}

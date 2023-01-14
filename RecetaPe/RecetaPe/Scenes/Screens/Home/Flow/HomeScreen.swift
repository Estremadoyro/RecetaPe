//
//  HomeScreen.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeScreen: UIViewController, Screen {
    // MARK: State
    private weak var presenter: HomePresentable?
    private lazy var navBarConfig = HomeNavBar(self)

    private lazy var disposeBag = DisposeBag()

    /// # UI
    private lazy var recipesCollection: RecipesCollection = {
        let collection = RecipesCollection()
        collection.collectionDelegate = self
        collection.presenter = presenter
        return collection
    }()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        return controller
    }()

    private lazy var searchBar: UISearchBar = {
        let bar = searchController.searchBar
        return bar
    }()

    // MARK: Initializers
    init(presenter: HomePresentable) {
        super.init(nibName: nil, bundle: nil)

        self.presenter = presenter
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Life Cycle
extension HomeScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureBindings()
        loadRecipes()
    }
}

private extension HomeScreen {
    func configureBindings() {
        guard let recipesObervable = presenter?.recipes.asObservable() else { return }
        let searchObservable = searchBar.rx.text
            .asObservable()
            .compactMap { $0 }
//            .filter { !$0.isEmpty && $0.count > 2 }
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
        
        Observable.combineLatest(recipesObervable, searchObservable)
            .asDriver(onErrorJustReturn: ([], ""))
            .drive { [weak self] (recipes, input) in
                guard let self = self else { return }
                let filteredRecipes = self.presenter?.filterRecipes(recipes, input: input)
                self.recipesCollection.updateSnapshot(with: filteredRecipes ?? [])
            }.disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.resetFilteredRecipes()
                
            }).disposed(by: disposeBag)

//        presenter?.recipes
//            .drive(onNext: { [weak self] (recipes) in
//                guard let self = self else { return }
//                self.recipesCollection.updateSnapshot(with: recipes)
//            }).disposed(by: disposeBag)
//
//        searchBar.rx.text
//            .asObservable()
//            .compactMap { $0 }
//            .filter { !$0.isEmpty && $0.count > 2 }
//            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { (text) in
//                Logger<Self>.log("Searching: \(text)")
//            }).disposed(by: disposeBag)
    }

    func loadRecipes() {
        presenter?.getAllRecipes()
    }
}

private extension HomeScreen {
    func configureScreen() {
        view.backgroundColor = RPeColor.white
        configureNavBar()
        layoutSubViews()
    }
}

private extension HomeScreen {
    func configureNavBar() {
        configureTitle()
        configureNavSearch()
    }

    func configureTitle() {
        navBarConfig.configureTitle(with: "Recipes")
    }

    func configureNavSearch() {
        navigationItem.searchController = searchController
    }
}

private extension HomeScreen {
    func layoutSubViews() {
        layoutRecipesColelction()
    }

    func layoutRecipesColelction() {
//        let recipes: [Recipe] = [.init(), .init(), .init()]
        recipesCollection.setup()
//        recipesCollection.updateSnapshot(with: recipes)

        let collection: UICollectionView = recipesCollection.getCollectionView()
        view.addSubview(collection)

        let xInset: CGFloat = 0
        let yInset: CGFloat = 10.0
        NSLayoutConstraint.activate([
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xInset),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xInset),
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: yInset),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeScreen: RPeCollectionable {
    func didSwipeLeading<T: Hashable>(with item: T) {
        guard let recipe = item as? Recipe else { return }
        presenter?.saveRecipe(recipe)
    }

    func didSwipeTrailing<T: Hashable>(with item: T) {
        guard let recipe = item as? Recipe else { return }
        presenter?.deleteRecipe(id: recipe.id)
    }

    func didSelectItem<T: Hashable>(with item: T) {
        guard let recipe = item as? Recipe else { return }
        presenter?.handle(action: .transition(.recipeDetail(recipe: recipe)))
    }
}

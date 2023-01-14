//
//  RecipesCollection.swift
//  RecetaPe
//
//  Created by Leonardo  on 9/01/23.
//

import UIKit

enum RecipeSection: Hashable {
    case recipes
}

final class RecipesCollection {
    // MARK: State
    private lazy var collectionObj: RPeCollection<RecipeSection, Recipe> = {
        let _collection = RPeCollection<RecipeSection, Recipe>()
        return _collection
    }()

    /// # Cell Registrations
    typealias RecipeCellRegistration = UICollectionView.CellRegistration<RecipeCell, Recipe>
    private let recipeCell = RecipeCellRegistration { (cell, _, recipe) in
        cell.backgroundConfiguration = RecipesCollection.getCellBackgroundConfig(with: cell)
        cell.recipe = recipe
        cell.setup()
    }

    /// # Delegates
    weak var collectionDelegate: RPeCollectionable?
    weak var presenter: HomePresentable?

    // MARK: Initializers
    init() {
        collectionObj.layoutDelegate = self
        collectionObj.dataSourceDelegate = self
        collectionObj.tapEventsDelegate = self
        configureCollection()
    }

    // MARK: Methods
    func setup() {
        collectionObj.setup()
    }

    func reset() {
        collectionObj.reset()
    }

    func getCollectionView() -> UICollectionView {
        collectionObj.getCollection()
    }

    func updateSnapshot(with recipes: [Recipe]) {
        collectionObj.updateSnapshot {
            (RecipeSection.recipes, recipes)
        }
    }
}

// MARK: Private methods
private extension RecipesCollection {
    func configureCollection() {
        let collection = getCollectionView()
        collection.showsVerticalScrollIndicator = true
        collection.showsHorizontalScrollIndicator = false
        collection.alwaysBounceHorizontal = false
    }

    static func getCellBackgroundConfig(with cell: RecipeCell) -> UIBackgroundConfiguration {
        var background = UIBackgroundConfiguration.listPlainCell()
        background.backgroundColorTransformer = UIConfigurationColorTransformer { _ in
            // No background color feedback.
            // guard let state = cell?.configurationState else { return .clear }
            // return state.isSelected || state.isHighlighted ? UIColor.systemGray6 : .clear
            UIColor.clear
        }
        return background
    }

    /// Save recipe.
    func getLeadingSwipeActions(_ indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let saveAction = UIContextualAction(style: .normal, title: "Save") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            guard let recipe = self.collectionObj.getDiffableDataSource()?.itemIdentifier(for: indexPath) else {
                completion(false); return
            }
            self.collectionDelegate?.didSwipeLeading(with: recipe)
            completion(true)
        }

        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        let icon = RPeIcon.save.withConfiguration(configuration)
        saveAction.image = icon
        saveAction.backgroundColor = UIColor.systemOrange

        return UISwipeActionsConfiguration(actions: [saveAction])
    }

    /// Delete recipe.
    func getTrailingSwipeActions(_ indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            guard let recipe = self.collectionObj.getDiffableDataSource()?.itemIdentifier(for: indexPath) else {
                completion(false); return
            }
            self.collectionDelegate?.didSwipeTrailing(with: recipe)
            completion(true)
        }

        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        let icon = RPeIcon.trash.withConfiguration(configuration)
        deleteAction.image = icon

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: Delegates
extension RecipesCollection: RPeColllectionLayoutable {
    /// https://developer.apple.com/videos/play/wwdc2020/10026/
    /// https://www.wwdcnotes.com/notes/wwdc20/10026/
    /// Using CompositionalLayout's list type.
    func getSection(_ sectionIndex: Int, _ env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        // Configuration
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.trailingSwipeActionsConfigurationProvider = getTrailingSwipeActions
        configuration.leadingSwipeActionsConfigurationProvider = getLeadingSwipeActions

        // List section
        let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: env)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 8.0

        return section
    }
}

extension RecipesCollection: RPeCollectionDataSourceable {
    func registerCells() {
        collectionObj.getCollection().register(RecipeCell.self,
                                               forCellWithReuseIdentifier: RecipeCell.resuseIdentifier)
    }

    func provideCell<T: Hashable>(_ collection: UICollectionView, _ indexPath: IndexPath, _ item: T) -> UICollectionViewCell? {
        guard let recipe = item as? Recipe else { return nil }
        return recipeCell.cellProvider(collection, indexPath, recipe)
    }
}

extension RecipesCollection: RPeTapEventsSendable {
    func didTapCell(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = collectionObj.getDiffableDataSource()?.itemIdentifier(for: indexPath) else {
            Logger<Self>.log("Error tapping cell.", .error)
            return
        }
        collectionDelegate?.didSelectItem(with: item)
    }
}

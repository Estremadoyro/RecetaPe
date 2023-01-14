//
//  RPeCollection.swift
//  RecetaPe
//
//  Created by Leonardo  on 9/01/23.
//

import UIKit

protocol RPeCell {
    static var resuseIdentifier: String { get set }
    func setup()
}

// MARK: Private protocols
protocol RPeCollectionDataSourceable: AnyObject {
    func registerCells()
    func provideCell<T: Hashable>(_ collection: UICollectionView, _ indexPath: IndexPath, _ item: T) -> UICollectionViewCell?
}

/// Gets a Compositional Layout section, it could be more generic if it provided the full layout but for this project purposes it serves just fine.
protocol RPeColllectionLayoutable: AnyObject {
    func getSection(_ sectionIndex: Int, _ env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
}

protocol RPeTapEventsSendable: AnyObject {
    func didTapCell(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

// MARK: Client protocols
/// Swipe actions are only available for **List** collection layout sections or types. Therefore the RPeCollection's client determines if it's needed or not.
protocol RPeCollectionable: AnyObject {
    /// Called when **finished** swiping leading.
    func didSwipeLeading<T: Hashable>(with item: T)
    /// Called when **finished** swiping trailing.
    func didSwipeTrailing<T: Hashable>(with item: T)
    /// Callend when item selected
    func didSelectItem<T: Hashable>(with item: T)
}

final class RPeCollection<Section: Hashable, Item: Hashable> {
    // MARK: State
    /// # Typealias
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    /// # CollectionView
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: getLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = RPeColor.white
        return collection
    }()

    /// # Snapshot
    private var snapshot = Snapshot()

    /// # DataSource
    private lazy var dataSource: DataSource? = {
        let ds = getDataSource()
        collectionView.dataSource = ds
        collectionView.delegate = collectionDelegate
        return ds
    }()

    /// # UICollection Delegate
    private lazy var collectionDelegate: RPeCollectionDelegate = {
        let obj = RPeCollectionDelegate()
        obj.delegate = tapEventsDelegate
        return obj
    }()

    /// # Delegates
    weak var dataSourceDelegate: RPeCollectionDataSourceable?
    weak var layoutDelegate: RPeColllectionLayoutable?
    weak var tapEventsDelegate: RPeTapEventsSendable?

    // MARK: Initializers
    init() {}

    // MARK: Methods

    /// Must be called before any other method.
    func setup() {
        registerCells()
    }

    func getCollection() -> UICollectionView {
        return collectionView
    }

    func getDiffableDataSource() -> DataSource? {
        return dataSource
    }

    func updateSnapshot(completion: () -> (Section, [Item]?)) {
        let sectionItem: (section: Section, items: [Item]?) = completion()

        // Check if section already exists
        if snapshot.indexOfSection(sectionItem.section) == nil {
            snapshot.appendSections([sectionItem.section])
        }

        guard let items = sectionItem.items else { return }
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: sectionItem.section))
        
        snapshot.appendItems(items, toSection: sectionItem.section)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func reset() {
        snapshot = Snapshot()
    }
}

private extension RPeCollection {
    func registerCells() {
        dataSourceDelegate?.registerCells()
    }

    func getDataSource() -> DataSource {
        return DataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            guard let self = self else { return nil }
            return self.dataSourceDelegate?.provideCell(collectionView, indexPath, item)
        })
    }

    func getLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else {
                fatalError(Logger<Self>.log("Error: No instance found.", .error))
            }
            return self.layoutDelegate?.getSection(sectionIndex, environment)
        }
    }
}

//
//  RecipeRepository.swift
//  RecetaPe
//
//  Created by Leonardo  on 11/01/23.
//

import RxSwift

protocol IRecipeRepository {
    // Each method returns a new observable with a sequence of the data updated.
    func addRecipe(_ recipe: [Recipe]) -> Observable<[Recipe]>
    func saveRecipe(_ recipe: [Recipe]) -> Observable<[Recipe]>
    func deleteRecipe(_ recipe: [Recipe]) -> Observable<[Recipe]>
    func getRecipes() -> Observable<[Recipe]?>
}

final class RecipeRepository: IRecipeRepository {
    // MARK: State
    private let networkManager: RemoteRequestable
    private let localManager: LocalRequestable

    // MARK: Initializers
    init(networkManager: RemoteRequestable, localManager: LocalRequestable) {
        self.networkManager = networkManager
        self.localManager = localManager
    }

    // MARK: Methods
    func getRecipes() -> Observable<[Recipe]?> {
        return .create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.networkManager.request(RecipeData.self, service: .getRecipe) { (result) in
                switch result {
                    case .success(let data):
                        observer.onNext(data?.recipes)
                    case .failure(let error):
                        observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func addRecipe(_ recipe: [Recipe]) -> Observable<[Recipe]> {
        return Observable.just([])
    }

    func saveRecipe(_ recipe: [Recipe]) -> Observable<[Recipe]> {
        return Observable.just([])
    }

    func deleteRecipe(_ recipe: [Recipe]) -> Observable<[Recipe]> {
        return Observable.just([])
    }
}

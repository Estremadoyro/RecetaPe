//
//  Recipe.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit
import MapKit

struct RecipeData: Codable {
    // MARK: Parameters
    var recipes: [Recipe]
    
    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case recipes
    }
    
    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recipes = try container.decodeIfPresent([Recipe].self, forKey: .recipes) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.recipes, forKey: .recipes)
    }
    
    // MARK: Initializers
    init() {
        self.recipes = [Recipe]()
    }
}

/// Needed to make it a class in order to hold a state of imageContent.
/// However fetching the image again shouldn't be a problem as it will already have been cached in the home screen.
final class Recipe: Codable, Hashable {
    // MARK: Parameters
    var id = UUID().uuidString
    var name: String
    var description: String
    var rating: CGFloat
    var ingredients: [String]
    var image: String
    var location: Location
    var imageContent: UIImage?
    
    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case rating
        case ingredients
        case image
        case location
    }
    
    // MARK: Decoding Technique
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.rating = try container.decodeIfPresent(CGFloat.self, forKey: .rating) ?? 0.0
        self.ingredients = try container.decodeIfPresent([String].self, forKey: .ingredients) ?? []
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        self.location = try container.decodeIfPresent(Location.self, forKey: .location) ?? Location()
    }
    
    // MARK: Encoding Technique
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.description, forKey: .description)
        try container.encodeIfPresent(self.rating, forKey: .rating)
        try container.encodeIfPresent(self.ingredients, forKey: .ingredients)
        try container.encodeIfPresent(self.image, forKey: .image)
        try container.encodeIfPresent(self.location, forKey: .location)
    }
    
    // MARK: Hashing
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: Equatable
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: Initializers
    init() {
        self.name = "Recipe \(UUID().uuidString.prefix(5))"
        self.description = "Description \(UUID().uuidString.prefix(20))"
        self.rating = 10
        self.ingredients = []
        self.image = ""
        self.location = Location()
        self.imageContent = UIImage(named: "anya")
    }
}

final class Location: NSObject, Codable, MKAnnotation {
    // MARK: Parameters
    var latitude: CGFloat
    var longitude: CGFloat
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case title = "country"
        case subtitle = "capital"
    }
    
    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decodeIfPresent(CGFloat.self, forKey: .latitude) ?? 25.3548
        self.longitude = try container.decodeIfPresent(CGFloat.self, forKey: .longitude) ?? 51.1839
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Wakanda"
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle) ?? "Black Panther"
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // MARK: Initializers
    override init() {
        self.latitude = 25.3548
        self.longitude = 51.1839
        self.title = "Wakanda"
        self.subtitle = "Black Panther"
        self.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        super.init()
    }
}

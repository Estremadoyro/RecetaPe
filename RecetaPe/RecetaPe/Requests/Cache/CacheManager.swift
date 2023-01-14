//
//  CacheManager.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import Foundation

// MARK: - Cache Wrappers
/// Wrapper for NSCache **Key**.
final class CacheKey: NSObject {
    let key: String

    override var hash: Int { return key.hashValue }

    init(_ key: String) {
        self.key = key
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let cacheKey = object as? CacheKey else {
            return false
        }
        return cacheKey.key == self.key
    }
}

/// Wrapper for NSCache **Value** hasahble model.
final class CacheValue {
    let value: AnyHashable
    init(_ value: AnyHashable) {
        self.value = value
    }
}

protocol Cacheable {
    var storage: NSCache<CacheKey, CacheValue> { get }
    
    /// Save a cache value by a Key.
    /// - Parameter key: The key which locates the value.
    /// - Parameter value: The value to store under the Key
    func save(key: String, value: AnyHashable)

    /// Load value from the cache.
    /// - Parameter key: The key which to look up for the value.
    /// - Returns: A CacheValue, the Cache's value for the key
    func load(from key: String) -> CacheValue?
}

// MARK: Images cache
final class ImageCache: Cacheable {
    // MARK: State
    private(set) lazy var storage = NSCache<CacheKey, CacheValue>()
    
    // MARK: Initializers
    init() {}
    
    // MARK: Methods
    func save(key: String, value: AnyHashable) {
        let cacheKey = CacheKey(key)
        let cacheValue = CacheValue(value)
        storage.setObject(cacheValue, forKey: cacheKey)
    }

    func load(from key: String) -> CacheValue? {
        let cacheKey = CacheKey(key)
        return storage.object(forKey: cacheKey)
    }
}

// MARK: Cache Manager
final class CacheManager {
    // MARK: State
    private lazy var imageCache = ImageCache()

    // MARK: Initializers
    init() {}

    // MARK: Methods
    func getImageCache() -> ImageCache {
        return imageCache
    }
}

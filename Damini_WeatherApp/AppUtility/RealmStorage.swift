//
//  RealmStorage.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 25/09/24.
//

import RealmSwift
import UIKit

public final class RealmStorage {

    private var configuration: Realm.Configuration

    // Allow configuration to be injected, or use the default configuration
    public init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        self.configuration = configuration
    }

    // Private Realm instance
    public var realm: Realm {
        // Log the database URL if needed
        // let url = Realm.Configuration.defaultConfiguration.fileURL
        // Log.shared.printLog("Realm db ---> \(url as Any)", logType: .normal)
        return try! Realm(configuration: configuration) // swiftlint:disable:this force_try
    }

    func get<R: Object>(fromEntity entity: R.Type, withPredicate predicate: NSPredicate? = nil, sortedByKey sortKey: String? = nil, inAscending isAscending: Bool = true) -> Results<R> {
        var objects = realm.objects(entity)
        if predicate != nil {
            objects = objects.filter(predicate!)
        }
        if sortKey != nil {
            objects = objects.sorted(byKeyPath: sortKey!, ascending: isAscending)
        }
        return objects
    }

    /// Adds a object to Realm
    func add(_ object: Object, update: Realm.UpdatePolicy = .all) {
        try! self.realm.write { // swiftlint:disable:this force_try
            self.realm.add(object, update: update)
        }
    }

    /// Adds a list of objects to Realm
    func add<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        try! self.realm.write { // swiftlint:disable:this force_try
            self.realm.add(objects, update: .all)
        }
    }

    /// Deletes a  element from Realm
    func delete(_ object: Object) {
        try! self.realm.write { // swiftlint:disable:this force_try
            self.realm.delete(object)
        }
    }

    public func deleteAll() {
        try! self.realm.write { // swiftlint:disable:this force_try
            self.realm.deleteAll()
        }
    }

    /// Deletes a list of elements from Realm
    func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        try! self.realm.write { // swiftlint:disable:this force_try
            self.realm.delete(objects)
        }
    }
}

//
//  DataList.swift
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

public enum DataListError: Error {
    case filterAlreadyInTheList
    case filterDoesNotPresentInTheList
    
    case sortDescriptorAlreadyInTheList
    case sortDescriptoDoesNotPresentInTheList
}

public typealias QuickCollectionClosure<T> = (_ collection: [T]) -> ([T])

open class DataList<T> {
    
    // MARK: - Private
    fileprivate var collection = [T]()
    private var filters = [DataListFilter<T>]()
    private var sortDescriptors = [DataListSortDescriptor<T>]()
    
    // MARK: - Public
    public init() {
    }
    
    public convenience init(_ objects: [T]) {
        self.init()
        addObjects(objects)
    }
    
    public convenience init(_ objects: T...) {
        self.init()
        addObjects(Array<T>(objects))
    }
    
    /// Returns the list of objects stored in this list. All filters and sorting applied to this list is considered
    public func objects() -> [T] {
        var filteredCollection = collection
        
        for filter in filters {
            filteredCollection = filter.applyToCollection(filteredCollection)
        }
        
        for sortDescriptor in sortDescriptors {
            filteredCollection = sortDescriptor.applyToCollection(filteredCollection)
        }
        
        return filteredCollection
    }
    
    /// Returns the list of objects stored in this list. No filters and sorting are applied at all
    public func wildObjects() -> [T] {
        return collection
    }
    
    /// Adds objects to this list
    public func addObjects(_ objects: [T]) {
        collection.append(contentsOf: objects)
    }
    
    /// Removes all object from this list
    public func removeAll() {
        collection.removeAll()
    }
    
    /// Adds a new filter to this object list
    public func addFilter(_ filter: DataListFilter<T>) throws {
        guard filters.first(where: {$0 === filter}) == nil else {
            // fallback in case the provided filter is in the list already
            throw DataListError.filterAlreadyInTheList
        }
        
        filters.append(filter)
    }
    
    /// Add a new quick filter
    public func addFilter(_ closure: @escaping QuickCollectionClosure<T>) {
        let filter = QuickFilter<T>(closure: closure)
        filters.append(filter)
    }
    
    /// Removes the previously added filter from this object list
    public func removeFilter(_ filter: DataListFilter<T>) throws {
        guard let filterIndex = filters.index(where: {$0 === filter}) else {
            // fallback in case the provided filter not in the list
            throw DataListError.filterDoesNotPresentInTheList
        }
        
        filters.remove(at: filterIndex)
    }
    
    /// Removes all filters
    public func clearFilters() {
        filters.removeAll()
    }
    
    public func addSortDescriptor(_ descriptor: DataListSortDescriptor<T>) throws {
        guard sortDescriptors.first(where: {$0 === descriptor}) == nil else {
            // fallback in case the provided descriptor is in the list already
            throw DataListError.sortDescriptorAlreadyInTheList
        }
        
        sortDescriptors.append(descriptor)
    }
    
    /// Add a new quick sort descriptor
    public func addSortDescriptor(_ closure: @escaping QuickCollectionClosure<T>) {
        let descriptor = QuickSortDescriptor<T>(closure: closure)
        sortDescriptors.append(descriptor)
    }
    
    public func removeSortDescriptor(_ descriptor: DataListSortDescriptor<T>) throws {
        guard let index = sortDescriptors.index(where: {$0 === descriptor})else {
            // fallback in case the provided descriptor not in the list
            throw DataListError.sortDescriptoDoesNotPresentInTheList
        }
        
        sortDescriptors.remove(at: index)
    }
    
    /// Removes all sort descriptors
    public func clearSortDescriptors() {
        sortDescriptors.removeAll()
    }
}

// MARK: - Sequence
extension DataList: Sequence where T: Any {
    
    public var count: Int { return collection.count }
    
    public subscript(index: Int) -> T? {
        get {
            return collection.count > index ? collection[index] : nil
        }
    }
    
    public func makeIterator() -> ObjectListIterator<T> {
        return ObjectListIterator(collection: self)
    }
}

public struct ObjectListIterator<T>: IteratorProtocol {
    private var index = 0
    private var collection: DataList<T>
    
    init(collection: DataList<T>) {
        self.collection = collection
    }
    
    public mutating func next() -> T? {
        let objects = collection.objects()
        
        guard index < objects.count else {
            return nil
        }
        
        let child = objects[index]
        index += 1
        return child
    }
}


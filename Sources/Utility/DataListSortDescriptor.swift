//
//  DataListSortDescriptor.swift
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

open class DataListSortDescriptor<T> {
    
    public init() {
    }
    
    /// Applies a sorting to the specified collection. Default implementation does nothing.
    /// Subclasses must provide own collection sorting algorithms
    ///
    /// - Parameter collection: A collection of object that should be sorted
    /// - Returns: A sorted collection
    open func applyToCollection(_ collection: [T]) -> [T] {
        return collection
    }
}

class QuickSortDescriptor<T>: DataListSortDescriptor<T> {
    
    // MARK: - Private
    private var closure: QuickCollectionClosure<T>
    
    required init(closure: @escaping QuickCollectionClosure<T>) {
        self.closure = closure
    }
    
    override final func applyToCollection(_ collection: [T]) -> [T] {
        return closure(collection)
    }
}

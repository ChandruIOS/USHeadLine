//
//  GenericHandler.swift
//  USHeadlines
//
//  Created by siva chitran p on 12/08/22.
//

import Foundation

class GenericHandler<T> {
    typealias CompletionHandler = ((T) -> Void)
    var value: T {
        didSet {
            if (value.self as? [Any])?.count != 0 {
             self.notify()
            } else {
                self.notify()
            }
        }
    }
    private var observers = [String: CompletionHandler]()
    init(_ value: T) {
        self.value = value
    }
    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    deinit {
        observers.removeAll()
    }
}

class GenericDataSource<T>: NSObject {
    var data: GenericHandler<[T]> = GenericHandler([])
}

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}

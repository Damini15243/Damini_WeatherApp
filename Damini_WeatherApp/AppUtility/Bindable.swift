//
//  Bindable.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }

    func set(value: T) {
        self.value = value
    }

    lazy var observer: ((T?) -> Void)? = nil

    func bind(observer: @escaping (T?) -> Void) {
        self.observer = observer
    }
}

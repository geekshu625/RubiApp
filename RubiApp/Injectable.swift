//
//  Injectable.swift
//  RubiApp
//
//  Created by 松木周 on 2020/05/28.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation

public protocol Injectable {
    associatedtype Dependency
    init(dependency: Dependency)
}

public protocol FactoryMethodInjectable {
    associatedtype Dependency
    static func makeInstance(dependency: Dependency) -> Self
}

public protocol PropertyInjectable: class {
    associatedtype Dependency
    var dependency: Dependency! { get set }
}

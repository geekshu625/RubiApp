//
//  UIBarButtonItem.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/13.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import RxCocoa
import RxSwift

//UIBarButtonItemに対してRxSwiftでバインディングできないので補強
extension Reactive where Base: UIBarButtonItem {
    var isEnabled: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: base) { button, isEnable in
            button.isEnabled = isEnable
        }
    }
}

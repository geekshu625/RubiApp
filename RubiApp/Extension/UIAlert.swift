//
//  UIAlert.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/13.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import UIKit

protocol AlertProtocol where Self: UIViewController {
    func showAlert(title: String?, message: String?, callback: @escaping () -> Void)
}

extension AlertProtocol {
    func showAlert(title: String?, message: String?, callback: @escaping () -> Void) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default) { _ in
                                        callback()
        }
        let cancelAction = UIAlertAction(title: "キャンセル",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

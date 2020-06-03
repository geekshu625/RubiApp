//
//  SavedRouter.swift
//  RubiApp
//
//  Created by 松木周 on 2020/06/03.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import Rswift

class SavedRouter {

    private init() {}

    static func moveToSettingViewController(from viewController: SavedViewController) {

        let settingViewController = R.storyboard.setting.instantiateInitialViewController()!

        viewController.navigationController?.pushViewController(settingViewController, animated: true)

    }

}

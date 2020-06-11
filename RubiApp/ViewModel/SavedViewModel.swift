//
//  SavedViewModel.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/12.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation

class SavedViewModel {

    //RealmDBから個別データ削除
    func deleteSavelist(savelist: Savelist) {
        SavelistManager.delete(savelist: savelist)
    }

}

//
//  ViewModelProtocol.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

protocol ListViewModelProtocol {
    associatedtype Data:IdentifiableType, Equatable
    typealias SectionModel = AnimatableSectionModel<Int, Data>
    
    var dataObservable: Observable<[SectionModel]>{get}
}


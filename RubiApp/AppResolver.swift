//
//  AppResolver.swift
//  RubiApp
//
//  Created by 松木周 on 2020/05/28.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import DIKit

protocol AppResolver: DIKit.Resolver {
    func provideResolver() -> AppResolver

    func provideHomeViewModel() -> HomeViewModel

    func provideHomeConvertUsecase() -> HomeConvertSentenseUsecaseProtocol
}

final class AppResolverImpl: AppResolver {

    private let homeUsecase = HomeUsecase()

    func provideResolver() -> AppResolver {
        return self
    }

    func provideHomeViewModel() -> HomeViewModel {
        let homeConvertUsecase = resolveHomeConvertSentenseUsecaseProtocol()
        return HomeViewModel(dependency: .init(homeConvertUsecase: homeConvertUsecase))
    }

    func provideHomeConvertUsecase() -> HomeConvertSentenseUsecaseProtocol {
        return homeUsecase
    }

}

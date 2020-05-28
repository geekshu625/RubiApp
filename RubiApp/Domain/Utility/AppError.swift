//
//  AppError.swift
//  RubiApp
//
//  Created by 松木周 on 2020/05/28.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation

enum AppError: Error {
    case network(Int)
    case server(Int)
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .network(let errorCode):
            return NetworkError(errorCode: errorCode).message

        case .server(let errorCode):
            return ServerError(errorCode: errorCode).message
        }
    }
}

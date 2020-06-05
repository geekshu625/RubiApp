//
//  HomeUsecase.swift
//  RubiApp
//
//  Created by 松木周 on 2020/05/27.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import Alamofire

final class HomeUsecase {

    // swiftlint:disable identifier_name
    private (set) var _convertedSentence: ConvertedResponse?
    // swiftlint:enable identifier_name

}

extension HomeUsecase: HomeConvertSentenseUsecaseProtocol {

    var convertedSentence: ConvertedResponse? {
        return _convertedSentence
    }

    func postConvertSentence(sentence: String, completion: @escaping ((Result<Void, AppError>) -> Void)) {

        let request = HomeRepository.PostConvertSentence(sentence: sentence)
        let body = try? JSONEncoder().encode(request.body)

        let task = AF.upload(body!, with: request.makeRequest())
            .response { (response) in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }

                    //APIのエラー処理
                    if let errorModel = try? JSONDecoder().decode(APIErrorRooter.self, from: data) {
                        completion(.failure(AppError.server(errorModel.error.code)))
                    }

                    let convertSentence = try? JSONDecoder().decode(ConvertedResponse.self, from: data)

                    self._convertedSentence = convertSentence
                    completion(.success(()))

                case .failure(let error):
                    //ネットワークのエラー処理
                    completion(.failure(AppError.network(error._code)))
                }
        }

        task.resume()

    }

}


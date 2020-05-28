//
//  HomeUsecase.swift
//  RubiApp
//
//  Created by 松木周 on 2020/05/27.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import Alamofire

final class HomeUsecase {}

extension HomeUsecase: HomeConvertUsecaseProtocl {

    func postKanzi(sentence: String, completion: @escaping ((Result<ConvertedResponse, AppError>) -> Void)) {

        let request = HomeRepository.PostKanzi(sentence: sentence)
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

                    let hiragana = try? JSONDecoder().decode(ConvertedResponse.self, from: data)

                    //swiftlint:disable:next force_cast
                    completion(.success(hiragana!))

                case .failure(let error):
                    //ネットワークのエラー処理
                    completion(.failure(AppError.network(error._code)))
                }
        }

        task.resume()

    }

}


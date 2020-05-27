//
//  HomeUsecase.swift
//  RubiApp
//
//  Created by 松木周 on 2020/05/27.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

//TODO: Usecase層に責務としてここに持たせるべきではない、ViewControllerかViewModelで宣言するべき
protocol HomeConvertUsecaseProtocl: AnyObject {
    func postKanzi<Request: APIRequest>(request: Request) -> Observable<Request.ResponseObject>
}

final class HomeUsecase {}

extension HomeUsecase: HomeConvertUsecaseProtocl {

    func postKanzi<Request: APIRequest>(request: Request) -> Observable<Request.ResponseObject> {

        return Observable.create { [weak self] observer -> Disposable in
            guard let `self` = self else { return Disposables.create {} }

            let body = try? JSONEncoder().encode(request.body)

            let task = AF.upload(body!, with: request.makeRequest())
                .response { (response) in
                    switch response.result {
                    case .success:
                        guard let data = response.data else { return }

                        //APIのエラー処理
                        if let errorModel = try? JSONDecoder().decode(APIErrorRooter.self, from: data) {
                            let apiError = HiraganaAPIError.init(errorCode: errorModel.error.code)
                            observer.onError(apiError)
                        }

                        let hiragana = try? JSONDecoder().decode(ConvertedResponse.self, from: data)

                        //swiftlint:disable:next force_cast
                        observer.onNext(hiragana as! Request.ResponseObject)


                    case .failure(let error):
                        //ネットワークのエラー処理
                        let connectingError = ConnectionError(errorCode: error._code)
                        observer.on(.error(connectingError))
                    }
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }

        }

    }

}


//
//  APIClient.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class HiraganaAPIClient {
    
    func call<Request: APIRequest>(request: Request) -> Observable<Request.ResponseObject> {
        
        return Observable.create { [weak self] observer -> Disposable in
            guard let `self` = self else { return Disposables.create {} }
            
            var urlRequest = URLRequest(url: URL(string: request.path)!)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = try? JSONEncoder().encode(request.body)
            
            let task = AF.upload(body!, with: urlRequest)
                .response { (response) in
                    switch response.result {
                    case .success(_):
                        guard let data = response.data else { return }
                        
                        //APIのエラー処理
                        if let errorModel = try? JSONDecoder().decode(APIErrorRooter.self, from: data) {
                            let apiError = HiraganaAPIError.init(errorCode: errorModel.error.code)
                            observer.onError(apiError)
                        }
                        
                        let hiragana = try? JSONDecoder().decode(Hiragana.self, from: data)
                        DispatchQueue.main.async {
                            observer.onNext(hiragana as! Request.ResponseObject)
                        }
                        
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


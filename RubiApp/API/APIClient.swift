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
    
    func post<Request: APIRequest>(request: Request) -> Observable<Request.ResponseObject> {
        
        return Observable.create { [weak self] observer -> Disposable in
            guard let `self` = self else { return Disposables.create {} }
            //TODO: リファクタリング
            var urlRequest = URLRequest(url: URL(string: request.path)!)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = try? JSONEncoder().encode(request.body)
            
            let task = AF.upload(body!, with: urlRequest)
                .response { (response) in
                    guard let data = response.data else { return }
                    do {
                        //TODO: API側のエラー処理
                        let hiragana = try JSONDecoder().decode(Hiragana.self, from: data)
                        DispatchQueue.main.async {
                            observer.onNext(hiragana as! Request.ResponseObject)
                        }
                    } catch {
                        //TODO: ネットワークのエラー処理を追加
                    }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}


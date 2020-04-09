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

            return Disposables.create {
            }
        }
    }
}


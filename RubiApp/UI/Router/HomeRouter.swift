//
//  HomeRouter.swift
//  RubiApp
//
//  Created by 松木周 on 2020/06/03.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import SafariServices

class HomeRouter {

    private init() {}

    static func moveToSearchWordWebView(from viewController: HomeViewController, searchSentence: String) {

        let urlString: String = "https://dictionary.goo.ne.jp/srch/all/\(searchSentence)/m0u/"
        guard let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        guard let url = URL(string: encodeUrlString) else { return }

        let vc = SFSafariViewController(url: url)

        viewController.present(vc, animated: true, completion: nil)

    }

}

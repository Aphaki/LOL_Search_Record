//
//  UIImageView.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/10.
//

import Foundation
import UIKit

extension UIImageView {
    func load(urlString: String) {
//        DispatchQueue.global().async { [weak self] in
//            guard let url = URL(string: urlString) else { return }
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//
//        }
       let img = NetworkManager.shared.downloadImage(urlStr: urlString)
        DispatchQueue.main.async {
            self.image = img
        }
    }
}

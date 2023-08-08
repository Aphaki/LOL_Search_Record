//
//  UIImageView.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/10.
//

import UIKit

extension UIImageView {
    // 가져오거나(폴더네임, 이미지네임) 안되면 url에서 다운로드
    func loadImage(from urlString: String, folderName: String, imgName: String) {
        
        if let cacheImage =
            LocalFileManager.shared.getImageFromImgURL(imgName: imgName, folderName: folderName) {
            DispatchQueue.main.async {
                self.image = cacheImage
            }
        } else {
            guard let url = URL(string: urlString) else {
                print("extension UIImageView - loadFromUrl() - Unvalid URL : \(urlString)")
                return }
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let safeData = data else {
                    print("extension UIImageView - loadFromUrl() - this URL is not return DATA : \(urlString)")
                    return
                }
//                guard let img = UIImage(data: safeData) else {
//                    print("extension UIImageView - loadFromUrl() - This URL Data is not Image : \(urlString)")
//                    return
//                }
                if let img = UIImage(data: safeData) {
                    DispatchQueue.main.async {
                        self.image = img
                        LocalFileManager.shared.saveImage(image: img, folderName: folderName, imgName: imgName)
                    }
                } else {
                    let emptyItemImg = UIImage(named: "EmptyItem")!
                    DispatchQueue.main.async {
                        self.image = emptyItemImg
                        LocalFileManager.shared.saveImage(image: emptyItemImg, folderName: folderName, imgName: imgName)
                    }
                    
                }
                
                
            }
            .resume()
        }
        
        self.layer.cornerRadius = 5
    }
}

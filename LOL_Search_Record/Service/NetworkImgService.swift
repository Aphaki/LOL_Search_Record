//
//  NetworkImgService.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/10.
//

import Foundation
import UIKit

class NetworkImgService {
    
    private let fileManager = LocalFileManager.shared
    private let folderName = "network_images"
    private let imageName: String
    private let urlString: String
    private(set) var uiImage: UIImage?
    
    init(urlString: String) {
        self.urlString = urlString
        self.imageName = urlString // url 로 안되면 변경 필요
    }
    
    func getImgFromNetworkOrLocal() {
        if let localImg = fileManager.getImageFromImgURL(imgName: imageName, folderName: folderName) {
            uiImage = localImg
            print("이미지 가져오기 - 로컬")
        } else {
            downloadNetworkImg()
            print("이미지 다운로드 - 네트워크")
        }
    }
    
    func downloadNetworkImg() {
        do {
            let downloadImg = try NetworkManager.shared.requestUrlImage(urlString: imageName)
            self.uiImage = downloadImg
            self.fileManager.saveImage(image: downloadImg, folderName: folderName, imgName: imageName)
        } catch {
            print("NetworkImgService - 네트워크 이미지 다운로드 중 에러")
        }
    }
}

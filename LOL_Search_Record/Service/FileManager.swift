//
//  FileManager.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/10.
//

import Foundation

import UIKit

class LocalFileManager {
    static let shared = LocalFileManager()
    
    init() { }
    
    func saveImage(image: UIImage, folderName: String, imgName: String) {
        createFolderIfNeed(folderName: folderName)
        
        guard
            let data = image.pngData(),
            let imgURL = getImgURL(folderName: folderName, imgName: imgName)
        else { return }
        do {
            try data.write(to: imgURL)
        } catch let error {
            print("이미지 저장중에 에러 발생: \(error)")
        }
    }
    func getImageFromImgURL(imgName: String, folderName: String) -> UIImage? {
        guard
            let imgURL = getImgURL(folderName: folderName, imgName: imgName),
            FileManager.default.fileExists(atPath: imgURL.path) else { return nil}
        return UIImage(contentsOfFile: imgURL.path)
    }
    
    private func getFolderURL(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(folderName)
    }
    
    private func createFolderIfNeed(folderName: String) {
        guard let folderURL = getFolderURL(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            } catch let error {
                print("디렉토리 생성중 에러: \(error)")
            }
        }
    }
    private func getImgURL(folderName: String, imgName: String) -> URL? {
        guard let folderURL = getFolderURL(folderName: folderName) else { return nil }
        return folderURL.appendingPathComponent(imgName + ".png")
    }
}

//
//  UIImageView+Extension.swift
//  Uni
//
//  Created by nguyen gia huy on 16/11/2020.
//

import Foundation
import UIKit
import FirebaseStorage
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImage(urlString: String) {
        self.image = AppIcon.icDefaultImageSquare
        let url = NSURL(string: urlString)
        if let cachedImage = imageCache.object(forKey: url!) as? UIImage {
            self.image = cachedImage
            return
        }
        let storageRef = Storage.storage().reference()
        let ref = storageRef.child("\(urlString)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        _ = ref.getData(maxSize: 1 * 2048 * 2048, completion:  { [self] data,error in
            if error != nil{
                print(error?.localizedDescription as Any)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: url!)
                    self.image = downloadedImage
                }
            }
        })
        
    }
}

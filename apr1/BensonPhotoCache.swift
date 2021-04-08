//
//  BensonPhotoCache.swift
//  apr1
//
//  Created by Benson on 2021/4/8.
//

import UIKit

class BensonPhotoCache: NSObject {
    static let sharedInstance: BensonPhotoCache = {
        let shared = BensonPhotoCache()
        return shared
    }()
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    public func fetchImageFromCache(_ key: String) -> UIImage? {
        if let cacheImage = self.imageCache.object(forKey: key as NSString) {
            return cacheImage
        } else {
            return nil
        }
    }
    
    public func saveImageCache(_ image: UIImage, key: String) {
        self.imageCache.setObject(image, forKey: key as NSString)
    }
}

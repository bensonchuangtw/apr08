//
//  PhotosViewModel.swift
//  apr1
//
//  Created by Benson on 2021/4/8.
//

import UIKit

class PhotosViewModel: NSObject {
    private let photoModel: PhotosModel = PhotosModel.init()
    public private(set) var loadCompleted: Bool = false
    
    public func loadPhotos (completion: @escaping (Bool) -> Void) {
        self.photoModel.requestPhotosAPI { (success: Bool) in
            self.loadCompleted = true
            
            completion(success)
        }
    }
    
    public func getCollectionRows() -> Int {
        guard self.loadCompleted == true else {
            return 0
        }
        
        return self.photoModel.getPhotosCount()
    }
    
    public func getPhotoDetail(_ indexPath: IndexPath) -> (Int?, String?, String?) {
        guard self.loadCompleted == true else {
            return (nil, nil, nil)
        }
        
        return self.photoModel.getPhotoIDTitle(indexPath.row)
    }
    
    public func requestPhoto(_ indexPath: IndexPath, tag: Int, completion: @escaping (Int, UIImage?) -> Void) {
        guard self.loadCompleted == true else {
            completion(tag, nil)
            return
        }
        
        self.photoModel.requestPhoto(indexPath.row, tag: tag, completion: completion)
    }
}

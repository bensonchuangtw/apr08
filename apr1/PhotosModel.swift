//
//  PhotosModel.swift
//  apr1
//
//  Created by Benson on 2021/4/8.
//

import UIKit
import Alamofire

class PhotoObj: Codable {
    let albumId: Int?
    let id: Int?
    let title: String?
    let url: String?
    let thumbnailUrl: String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.albumId = try container.decodeIfPresent(Int.self, forKey: .albumId)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.thumbnailUrl = try container.decodeIfPresent(String.self, forKey: .thumbnailUrl)
    }
}

class PhotosModel: NSObject {
    static let API_PATH: String = "https://jsonplaceholder.typicode.com/photos"
    
    private var photos: [PhotoObj] = []
    
    public func requestPhotosAPI(completion: @escaping (Bool) -> Void) {
        let request = AF.request(PhotosModel.API_PATH)
        request.responseJSON { (response: AFDataResponse<Any>) in
            if let jsonData = response.data {
                do {
                    let objs = try JSONDecoder().decode([PhotoObj].self, from: jsonData)
                    self.photos = objs
                    completion(true)
                } catch let error {
                    print(error.localizedDescription)
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    public func getPhotosCount() -> Int {
        return self.photos.count
    }
    
    public func getPhotoIDTitle(_ index: Int) -> (Int?, String?, String?) {
        guard self.photos.count > index else {
            return (nil, nil, nil)
        }
        
        let targetPhoto = self.photos[index]
        
        if let id = targetPhoto.id {
            return (id, "\(id)", targetPhoto.title)
        } else {
            return (targetPhoto.id, nil, targetPhoto.title)
        }
    }
    
    public func requestPhoto(_ index: Int, tag: Int, completion: @escaping (Int, UIImage?) -> Void) {
        guard self.photos.count > index else {
            completion(tag, nil)
            return
        }
        
        let targetPhoto = self.photos[index]
        
        if let thumbnailUrl = targetPhoto.thumbnailUrl {
            if let cacheThumbnail = BensonPhotoCache.sharedInstance.fetchImageFromCache(thumbnailUrl) {
                completion(tag, cacheThumbnail)
            } else {
                AF.request(thumbnailUrl).responseData { (response: AFDataResponse<Data>) in
                    if let imageData = response.data {
                        let tmpImage = UIImage.init(data: imageData)
                        if let image = tmpImage {
                            BensonPhotoCache.sharedInstance.saveImageCache(image, key: thumbnailUrl)
                        }
                        
                        completion(tag, tmpImage)
                    } else {
                        completion(tag, nil)
                    }
                }
            }
        } else {
            completion(tag, nil)
        }
    }
}

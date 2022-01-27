//
//  ImageManager.swift
//  teamTest
//
//  Created by San Byn Nguyen on 23.01.2022.
//

import Foundation
import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    private let cache = NSCache<NSString, NSData>()
    
    func load(url: URL, completion: @escaping(UIImage?, URL) -> Void){
        let cacheID = NSString(string: url.absoluteString)
        
        if let cachedData = cache.object(forKey: cacheID),
           let image = UIImage(data: cachedData as Data) {
            completion(image, url)
        } else {
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad
            request.httpMethod = "get"
            session.dataTask(with: request) { (data, response, error) in
                if let _data = data {
                    self.cache.setObject(_data as NSData, forKey: cacheID)
                    completion(UIImage(data: _data), url)
                } else {
                    completion(nil, url)
                }
            }.resume()
        }
    }
}

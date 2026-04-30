//
//  ImageCacheManager.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import UIKit

class ImageCache {
	static let shared = ImageCache()
	
	private let cache = NSCache<NSString, UIImage>()
	
	private init() {
		self.cache.countLimit = 100
	}
	
	func set(_ image: UIImage, forKey key: String) {
		cache.setObject(image, forKey: key as NSString)
	}
	
	func get(forKey key: String) -> UIImage? {
		return cache.object(forKey: key as NSString)
	}
}

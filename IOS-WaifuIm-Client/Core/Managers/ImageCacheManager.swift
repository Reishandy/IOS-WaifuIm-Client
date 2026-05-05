//
//  ImageCacheManager.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import UIKit

class ImageCache {
	static let shared = ImageCache()
	
	private let cache = NSCache<NSString, NSData>()
	
	func set(_ data: Data, forKey key: String) {
		cache.setObject(data as NSData, forKey: key as NSString)
	}
	
	func get(forKey key: String) -> Data? {
		return cache.object(forKey: key as NSString) as Data?
	}
}

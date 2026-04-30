//
//  ImageLoaderManager.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

@Observable
class ImageLoaderManager {
	var image: UIImage? = nil
	var isLoading = false
	
	private var downloadTask: Task<Void, Never>? = nil
	
	func load(from urlString: String) {
		if let cachedImage = ImageCache.shared.get(forKey: urlString) {
			self.image = cachedImage
			return
		}
		
		guard let url = URL(string: urlString) else { return }
		
		self.isLoading = true
		
		downloadTask = Task {
			do {
				let (data, _) = try await URLSession.shared.data(from: url)
				
				guard !Task.isCancelled else { return }
				
				if let downloadedImage = UIImage(data: data) {
					ImageCache.shared.set(downloadedImage, forKey: urlString)
					
					await MainActor.run {
						self.image = downloadedImage
						self.isLoading = false
					}
				}
			} catch {
				await MainActor.run {
					self.image = UIImage(systemName: "photo.trianglebadge.exclamationmark.fill")
					self.isLoading = false
				}
			}
		}
	}
	
	func cancel() {
		downloadTask?.cancel()
	}
}

//
//  ImageLoaderManager.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

@Observable
class ImageLoaderManager {
	var imageData: Data? = nil
	var isLoading: Bool = false
	var isError: Bool = false
	
	private var downloadTask: Task<Void, Never>? = nil
	
	func load(from urlString: String) {
		if let cachedImage = ImageCache.shared.get(forKey: urlString) {
			self.imageData = cachedImage
			return
		}
		
		guard let url = URL(string: urlString) else { return }
		
		self.isLoading = true
		
		downloadTask = Task {
			do {
				let (data, _) = try await URLSession.shared.data(from: url)
				
				guard !Task.isCancelled else { return }
				
				ImageCache.shared.set(data, forKey: urlString)
				
				await MainActor.run {
					self.imageData = data
					self.isError = false
					self.isLoading = false
				}
			} catch {
				await MainActor.run {
					self.isError = true
					self.isLoading = false
				}
			}
		}
	}
	
	func cancel() {
		downloadTask?.cancel()
	}
}

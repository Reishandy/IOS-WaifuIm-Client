//
//  ImageItemView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct ImageItemView: View {
	let imageUrl: String
	var onImageLoaded: ((UIImage) -> Void)? = nil
	
	@State private var imageLoaderManager = ImageLoaderManager()
	
	var body: some View {
		Group {
			if let image = imageLoaderManager.image {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fit)
			} else {
				Color.gray.opacity(0.6)
					.overlay {
						if imageLoaderManager.isError {
							VStack(spacing: 10) {
								Image(systemName: "photo.trianglebadge.exclamationmark.fill")
									.font(.largeTitle)
									.foregroundStyle(.black.opacity(0.5))
								
								Text("Failed to load image")
									.foregroundStyle(.black.opacity(0.5))
							}
						}
						else {
							ProgressView()
						}
					}
					.aspectRatio(contentMode: .fill)
			}
		}
		.task(id: imageUrl) {
			populate()
		}
		.onChange(of: imageLoaderManager.isError) {
			if imageLoaderManager.isError {
				populate()
			}
		}
	}
	
	private func populate() {
		imageLoaderManager.load(from: imageUrl)
		if let image = imageLoaderManager.image {
			onImageLoaded?(image)
		}
	}
}

#Preview() {
	ImageItemView(imageUrl: "https://github.com/Reishandy/Reishandy/blob/85b5bd0ef00735d277eaf41db3f28a5eb6e2c63a/repo/michiru_profile.webp?raw=true")
}

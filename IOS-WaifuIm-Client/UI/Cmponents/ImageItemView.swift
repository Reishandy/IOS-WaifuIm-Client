//
//  ImageItemView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI
import SDWebImageSwiftUI
import UniformTypeIdentifiers

struct ImageItemView: View {
	let imageUrl: String
	let width: CGFloat
	let height: CGFloat
	var onImageDataLoaded: ((Data) -> Void)? = nil
	
	@State private var imageLoaderManager = ImageLoaderManager()
	
	var body: some View {
		ZStack {
			if let imageData = imageLoaderManager.imageData {
				if imageData.imageUTType == .gif {
					AnimatedImage(data: imageData)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.transition(.opacity.combined(with: .scale(scale: 0.95)))
				} else {
					if let image = UIImage(data: imageData) {
						Image(uiImage: image)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.transition(.opacity.combined(with: .scale(scale: 0.95)))
					}
				}
			} else {
				Color.gray.opacity(0.6)
					.overlay {
						if imageLoaderManager.isError {
							VStack(spacing: 10) {
								Image(systemName: "photo.trianglebadge.exclamationmark")
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
					.transition(.opacity)
			}
		}
		.frame(width: width, height: height)
		.animation(.easeIn(duration: 0.3), value: imageLoaderManager.imageData)
		.task(id: imageUrl) {
			populate()
		}
		.onChange(of: imageLoaderManager.isError) {
			if imageLoaderManager.isError {
				populate()
			}
		}
		.onChange(of: imageLoaderManager.imageData) { oldValue, newValue in
			if let newImageData = newValue {
				onImageDataLoaded?(newImageData)
			}
		}
	}
	
	private func populate() {
		imageLoaderManager.load(from: imageUrl)
	}
}

#Preview() {
	ImageItemView(imageUrl: "https://github.com/Reishandy/Reishandy/blob/85b5bd0ef00735d277eaf41db3f28a5eb6e2c63a/repo/michiru_profile.webp?raw=true", width: 400, height: 400)
}

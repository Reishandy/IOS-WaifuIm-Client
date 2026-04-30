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
						ProgressView()
					}
					.aspectRatio(contentMode: .fit)
			}
		}
		.task(id: imageUrl) {
			imageLoaderManager.load(from: imageUrl)
			if let image = imageLoaderManager.image {
				onImageLoaded?(image)
			}
		}
	}
}

#Preview() {
	ImageItemView(imageUrl: "https://github.com/Reishandy/Reishandy/blob/85b5bd0ef00735d277eaf41db3f28a5eb6e2c63a/repo/michiru_profile.webp?raw=true")
}

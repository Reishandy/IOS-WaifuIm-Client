//
//  ImageItemView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct ImageItemView: View {
	var image: UIImage? = nil
	
	var body: some View {
		if let image = image {
			Image(uiImage: image)
				.resizable()
		} else {
			Color.gray.opacity(0.6)
				.overlay {
					ProgressView()
				}
		}
	}
}

#Preview() {
	ImageItemView()
}

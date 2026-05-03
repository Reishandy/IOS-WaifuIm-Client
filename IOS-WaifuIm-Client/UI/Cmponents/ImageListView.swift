//
//  ImageListView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 01/05/26.
//

import SwiftUI

struct ImageListView: View {
	@Environment(AppManager.self) private var appManager
	
	let imageResponses: [ResponseImage]
	let isLoading: Bool
	let isRandomOrder: Bool
	let hasMoreImage: Bool
	let populate: (Bool) -> Void
	
	@Binding var scrollPosition: ScrollPosition
	
	private var bottomText: String {
		if isRandomOrder {
			"Refresh to get new random images"
		} else if !hasMoreImage {
			"That is it, no more images"
		} else {
			"Pull to load more images"
		}
	}
	
    var body: some View {
		GeometryReader { geometry in
			let screenWidth = geometry.size.width
			
			ScrollView {
				LazyVStack {
					ForEach(imageResponses) { item in
						let displayHeight = (screenWidth / CGFloat(item.width)) * CGFloat(item.height)
						
						NavigationLink(
							value: Screen.imageDetailScreen(imageId: item.id)
						) {
							ImageItemView(imageUrl: item.url)
								.frame(height: displayHeight)
								.clipShape(RoundedRectangle(cornerRadius: 10))
								.padding(.bottom, -6)
								.padding(.horizontal, 2)
						}
					}
					
					if isLoading {
						ProgressView()
							.padding(.top, 12)
					} else {
						Text(bottomText)
							.opacity(0.4)
							.font(.subheadline)
							.padding(.top, 6)
					}
				}
			}
			.scrollPosition($scrollPosition)
			.onScrollGeometryChange(for: Bool.self) { geometry in
				let contentHeight = geometry.contentSize.height
				let containerHeight = geometry.containerSize.height
				let currentOffset = geometry.contentOffset.y
				
				return  currentOffset + containerHeight >= contentHeight
			} action: { oldValue, newValue in
				Task { @MainActor in
					if newValue && !oldValue && !isRandomOrder {
						populate(false)
					}
				}
			}
			.refreshable {
				populate(true)
			}
		}
    }
}

#Preview {
	ImageListView(
		imageResponses: [],
		isLoading: false,
		isRandomOrder: false,
		hasMoreImage: false,
		populate: {_ in },
		scrollPosition: .constant(ScrollPosition())
	)
}

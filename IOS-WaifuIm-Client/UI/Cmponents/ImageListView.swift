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
	let screenWidth: CGFloat
	let isRandomOrder: Bool
	let hasMoreImage: Bool
	let populate: (Bool) -> Void
	
	@Binding var shouldHideToolbars: Bool
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
		ScrollView {
			LazyVStack {
				ForEach(imageResponses) { item in
					let displayHeight = (screenWidth / CGFloat(item.width)) * CGFloat(item.height)
					
					NavigationLink(
						destination: ImageDetailScreen(
							imageId: item.id,
							onTagTap: {	slug in
								appManager.filterState = FilterState.defultFilter
								appManager.filterState.orderBy = .uploadedAt
								appManager.filterState.includedTags = [slug]
								
								populate(true)
							},
							onArtistTap: { id in
								appManager.filterState = FilterState.defultFilter
								appManager.filterState.orderBy = .uploadedAt
								appManager.filterState.includedArtists = [id]
								
								populate(true)
							}
						)
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
		.onScrollGeometryChange(for: ScrollState.self) { geometry in
			let contentHeight = geometry.contentSize.height
			let containerHeight = geometry.containerSize.height
			let currentOffset = geometry.contentOffset.y
			
			let reachedBottom = currentOffset + containerHeight >= contentHeight
			
			return ScrollState(offset: currentOffset, isAtBottom: reachedBottom)
		} action: { oldValue, newValue in
			Task { @MainActor in
				let isScrollingDown = newValue.offset > oldValue.offset
				
				if abs(newValue.offset - oldValue.offset) >= 40 {
					if isScrollingDown && !shouldHideToolbars {
						withAnimation() {
							shouldHideToolbars = true
						}
					} else if !isScrollingDown && shouldHideToolbars {
						withAnimation() {
							shouldHideToolbars = false
						}
					}
				}
				
				if newValue.isAtBottom && !oldValue.isAtBottom && !isRandomOrder {
					populate(false)
				}
			}
		}
		.refreshable {
			populate(true)
		}
    }
}

#Preview {
	ImageListView(
		imageResponses: [], isLoading: false, screenWidth: 400, isRandomOrder: false, hasMoreImage: false, populate: {_ in }, shouldHideToolbars: .constant(false), scrollPosition: .constant(ScrollPosition())
	)
}

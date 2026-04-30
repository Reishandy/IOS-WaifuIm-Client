//
//  ImageListScreen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct ImageListScreen: View {
	@Namespace private var imageListScreenNameSpace
	
	// TODO: Replace with real data
	@State private var dummyItem: [(width: CGFloat, height: CGFloat)] = [
		(100, 150),
		(1920, 1800),
		(1921, 1800),
		(1922, 1800),
		(1923, 1800),
		(1924, 1800),
		(1925, 1800),
		(1926, 1800),
		(1927, 1800),
		(1928, 1800),
		(2000, 1000)
	]
	
	@State private var shouldHideToolbars: Bool = false
	
	var body: some View {
		GeometryReader { geometry in
			let screenWidth = geometry.size.width
			
			ScrollView {
				ForEach(dummyItem, id:\.width) { item in
					let displayHeight = (screenWidth / item.width) * item.height
					
					NavigationLink(
						destination: ImageDetailScreen()
							.navigationTransition(.zoom(sourceID: item.width, in: imageListScreenNameSpace))
					) {
						ImageItemView(image: nil)
							.frame(height: displayHeight)
							.clipShape(RoundedRectangle(cornerRadius: 10))
							.padding(.bottom, -6)
							.padding(.horizontal, 2)
							.matchedTransitionSource(id: item.width, in: imageListScreenNameSpace)
					}
					
				}
				
				// TODO: Check for no more item and fetching status
				// TODO: and also when it is random filter
				Text("Pull to load more images")
					.opacity(0.4)
					.font(.subheadline)
					.padding(.top, 6)
			}
			.onTapGesture(count: 2) {
				// TODO: Check if this will work
				withAnimation() {
					shouldHideToolbars.toggle()
				}
			}
			.onScrollGeometryChange(for: ScrollState.self) { geometry in
				let contentHeight = geometry.contentSize.height
				let containerHeight = geometry.containerSize.height
				let currentOffset = geometry.contentOffset.y
				
				let reachedBottom = currentOffset + containerHeight >= contentHeight
				
				return ScrollState(offset: currentOffset, isAtBottom: reachedBottom)
			} action: { oldValue, newValue in
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
				
				if newValue.isAtBottom && !oldValue.isAtBottom {
					// TODO: Fetch new stuff
				}
			}
			.refreshable {
				// TODO: Refresh with await
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				VStack(alignment: .leading, spacing: -4) {
					Text("Waifu.im")
						.font(.largeTitle)
						.bold()
						.fixedSize()
					
					Text("A place for waifu illustrations")
						.opacity(0.4)
						.font(.callout)
						.fixedSize()
				}
			}
			.sharedBackgroundVisibility(.hidden)
			
			ToolbarItem(placement: .topBarTrailing) {
				// TODO: Refresh
				Image(systemName: "arrow.triangle.2.circlepath")
			}
			
			ToolbarItem(placement: .bottomBar) {
				NavigationLink(
					destination: TagsScreen()
				) {
					Image(systemName: "tag.fill")
						.padding(.trailing, -20)
				}
			}
			
			ToolbarItem(placement: .bottomBar) {
				NavigationLink(
					destination: ArtistScreen()
				) {
					Image(systemName: "person.3.fill")
						.padding(.trailing, 4)
				}
			}
			
			ToolbarSpacer(placement: .bottomBar)
			
			ToolbarItem(placement: .bottomBar) {
				// TODO: Filter sheet
				Image(systemName: "line.3.horizontal.decrease")
			}
		}
		.toolbarVisibility(shouldHideToolbars ? .hidden : .visible, for: .navigationBar, .bottomBar)
	}
}

#Preview {
	NavigationStack {
		ImageListScreen()
	}
}

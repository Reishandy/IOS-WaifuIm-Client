//
//  ImageListScreen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct ImageListScreen: View {
	@Namespace private var imageListScreenNameSpace
	
	@Environment(AppManager.self) private var appManager
	
	@State private var shouldHideToolbars: Bool = false
	@State private var isFilterSheetPresented: Bool = false
	
	var body: some View {
		@Bindable var appManager = appManager
		
		GeometryReader { geometry in
			let screenWidth = geometry.size.width
			
			if appManager.fetchedImageResponses.isEmpty {
				VStack {
					if appManager.isLoading {
						ProgressView()
					} else {
						EmptyStateView(
							iconName: "photo.badge.magnifyingglass.fill",
							title: "No Images Here",
							description: "Either it is empty, or you should check the filter (escpecially with the content rating)."
						)
					}
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else {
				ScrollView {
					ForEach(appManager.fetchedImageResponses) { item in
						let itemHeight = CGFloat(Double(item.height))
						let itemWidth = CGFloat(Double(item.width))
						let displayHeight = (screenWidth / itemWidth) * itemHeight
						
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
						Task {
							await populate()
						}
					}
				}
				.refreshable {
					await populate(isFresh: true)
				}
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
				Image(systemName: "arrow.triangle.2.circlepath")
					.onTapGesture {
						Task {
							await populate(isFresh: true)
						}
					}
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
				Image(systemName: "line.3.horizontal.decrease")
					.onTapGesture {
						isFilterSheetPresented = true
					}
					.matchedTransitionSource(id: "filterSheetSource", in: imageListScreenNameSpace)
			}
		}
		.task {
			await populate(isFresh: true)
		}
		.toolbarVisibility(shouldHideToolbars ? .hidden : .visible, for: .navigationBar, .bottomBar)
		.sheet(isPresented: $isFilterSheetPresented) {
			FilterSheetView()
				.navigationTransition(.zoom(sourceID: "filterSheetSource", in: imageListScreenNameSpace))
		}
		.alert(
			"Oops!",
			isPresented: $appManager.showError,
			presenting: appManager.error
		) { _ in
			Button("OK", role: .cancel) { }
			Button("Retry") {
				Task {
					await populate(isFresh: true)
				}
			}
		} message: { error in
			Text(error.localizedDescription)
		}
	}
	
	private func populate(isFresh: Bool = false) async {
		// TODO: Set pagination
		
		if isFresh {
			appManager.fetchedImageResponses = []
		} else {
			
		}
		
		await appManager.fetchImages()
	}
}

#Preview {
	NavigationStack {
		ImageListScreen()
			.environment(AppManager())
	}
}

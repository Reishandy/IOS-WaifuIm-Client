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
	@State private var isFetchingCooldown: Bool = false
	@State private var scrollPosition: ScrollPosition = ScrollPosition()
	
	var body: some View {
		@Bindable var appManager = appManager
		
		GeometryReader { geometry in
			let screenWidth = geometry.size.width
			
			VStack {
				if appManager.fetchedImageResponses.isEmpty {
					if appManager.isLoading {
						ProgressView()
					} else {
						EmptyStateView(
							iconName: "photo.badge.magnifyingglass.fill",
							title: "No Images Here",
							description: "Either it is empty, or you should check the filter (escpecially with the content rating)."
						)
					}
				} else {
					ImageListView(
						imageResponses: appManager.fetchedImageResponses,
						isLoading: appManager.isLoading,
						screenWidth: screenWidth,
						isRandomOrder: appManager.filterState.orderBy == .random,
						hasMoreImage: appManager.hasMoreImage,
						populate: { isFresh in
							await self.populate(isFresh: isFresh)
						},
						shouldHideToolbars: $shouldHideToolbars,
						scrollPosition: $scrollPosition
					)
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
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
		.statusBarHidden(true)
		.toolbarVisibility(shouldHideToolbars ? .hidden : .visible, for: .navigationBar, .bottomBar)
		.onAppear {
			shouldHideToolbars = false
		}
		.sheet(isPresented: $isFilterSheetPresented) {
			FilterSheetView(
				filterState: $appManager.filterState,
				onDismissPress: {
					isFilterSheetPresented = false
				},
				onApplyPress: {}
			)
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
		.animation(.easeInOut, value: appManager.fetchedImageResponses)
	}
	
	private func populate(isFresh: Bool = false) async {
		guard !isFetchingCooldown else { return }
		
		isFetchingCooldown = true
		Task {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
				isFetchingCooldown = false
			}
		}
		
		if isFresh {
			withAnimation() {
				scrollPosition.scrollTo(edge: .top)
				appManager.fetchedImageResponses = []
				appManager.filterState.page = 1
			}
		} else {
			appManager.filterState.page += 1
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

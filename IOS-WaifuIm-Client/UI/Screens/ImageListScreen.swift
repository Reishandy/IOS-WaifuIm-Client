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
	
	private var isRandomOrder: Bool {
		appManager.filterState.orderBy == .random
	}
	
	var body: some View {
		@Bindable var appManager = appManager
		
		GeometryReader { geometry in
			let screenWidth = geometry.size.width
			
			VStack {
				if appManager.fetchedImageResponses.isEmpty {
					if appManager.isFetchingImages {
						ProgressView()
					} else {
						EmptyStateView(
							iconName: "photo.badge.magnifyingglass.fill",
							title: "No Images Here",
							description: "Either it is empty, or you should check the filter (escpecially with the content rating).",
							actionButtonText: "Reset Filter"
						) {
							appManager.filterState = FilterState.defultFilter
							populate(isFresh: true)
						}
					}
				} else {
					ImageListView(
						imageResponses: appManager.fetchedImageResponses,
						isLoading: appManager.isFetchingImages,
						screenWidth: screenWidth,
						isRandomOrder: isRandomOrder,
						hasMoreImage: appManager.hasMoreImage,
						populate: { isFresh in
							self.populate(isFresh: isFresh)
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
				if isRandomOrder {
					Image(systemName: "arrow.triangle.2.circlepath")
						.onTapGesture {
							populate(isFresh: true)
						}
				} else {
					Image(systemName: "arrow.up")
						.onTapGesture {
							withAnimation {
								scrollPosition.scrollTo(edge: .top)
							}
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
					Image(systemName: "person.2.fill")
						.padding(.trailing, 4)
				}
			}
			
			ToolbarSpacer(placement: .bottomBar)
			
			ToolbarItem(placement: .bottomBar) {
				Button {
					isFilterSheetPresented = true
				} label: {
					Image(systemName: "line.3.horizontal.decrease")
				}
				.matchedTransitionSource(id: "filterSheetSource", in: imageListScreenNameSpace)
			}
		}
		.statusBarHidden(true)
		.toolbarVisibility(shouldHideToolbars ? .hidden : .visible, for: .navigationBar, .bottomBar)
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				if shouldHideToolbars {
					withAnimation {
						shouldHideToolbars = false
					}
				}
			}
		}
		.sheet(isPresented: $isFilterSheetPresented) {
			FilterSheetView(
				filterState: $appManager.filterState,
				onApplyPress: {
					isFilterSheetPresented = false
					Task {
						populate(isFresh: true)
					}
				}
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
					populate(isFresh: true)
				}
			}
		} message: { error in
			Text(error.localizedDescription)
		}
		.animation(.easeInOut, value: appManager.fetchedImageResponses)
	}
	
	private func populate(isFresh: Bool = false) {
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
		
		Task {
			await appManager.fetchImages()
		}
	}
}

#Preview {
	NavigationStack {
		ImageListScreen()
			.environment(AppManager())
	}
}

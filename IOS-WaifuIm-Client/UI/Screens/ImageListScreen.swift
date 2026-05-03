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
	@State private var isAccountShown: Bool = false
	
	private var isRandomOrder: Bool {
		appManager.filterState.orderBy == .random
	}
	
	var body: some View {
		@Bindable var appManager = appManager
		
		GeometryReader { geometry in
			let screenWidth = geometry.size.width
			
			VStack {
				if appManager.imageResponses.isEmpty {
					if appManager.isFetchingImages {
						ProgressView()
					} else {
						EmptyStateView(
							iconName: "photo.badge.magnifyingglass",
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
						imageResponses: appManager.imageResponses,
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
					Button {
						populate(isFresh: true)
					} label: {
						Image(systemName: "arrow.triangle.2.circlepath")
					}
				} else {
					Button {
						withAnimation {
							scrollPosition.scrollTo(edge: .top)
						}
					} label: {
						Image(systemName: "arrow.up")
					}
				}
			}
			
			ToolbarSpacer(placement: .topBarTrailing)
			
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					isAccountShown.toggle()
				} label: {
					if let avatarUrl = appManager.profile?.avatarUrl {
						ImageItemView(imageUrl: avatarUrl)
							.clipShape(Circle())
							.padding(-8)
					} else {
						Image(systemName: "person")
					}
				}
				.popover(isPresented: $isAccountShown) {
					AccountView(
						onSaveTap: { apiKey in
							isAccountShown = false
							
							Task {
								await appManager.storeAPIKey(apiKey: apiKey)
							}
						},
						onLogOutTap: {
							isAccountShown = false
							appManager.removeAPIKey()
						},
						profile: appManager.profile
					)
					.presentationCompactAdaptation(.popover)
				}
			}
			
			ToolbarItem(placement: .bottomBar) {
				NavigationLink(
					destination: TagsScreen(
						onTagTap: {	slug in
							appManager.filterState = FilterState.defultFilter
							appManager.filterState.orderBy = .uploadedAt
							appManager.filterState.includedTags = [slug]
							
							populate(isFresh: true)
						}
					)
				) {
					Image(systemName: "tag")
						.padding(.trailing, -40)
				}
			}
			
			ToolbarItem(placement: .bottomBar) {
				NavigationLink(
					destination: ArtistScreen(
						onArtistTap: { id in
							appManager.filterState = FilterState.defultFilter
							appManager.filterState.orderBy = .uploadedAt
							appManager.filterState.includedArtists = [id]
							
							populate(isFresh: true)
						}
					)
				) {
					Image(systemName: "person.2")
						.padding(.trailing, appManager.albumResponses != nil ? -16 : 8)
				}
			}
			
			if appManager.albumResponses != nil {
				ToolbarItem(placement: .bottomBar) {
					NavigationLink(
						destination: AlbumScreen()
					) {
						Image(systemName: "folder")
							.padding(.trailing, 10)
					}
					.transition(.opacity)
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
		.animation(.easeInOut, value: appManager.imageResponses)
		.animation(.easeInOut, value: appManager.albumResponses != nil)
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
				appManager.imageResponses = []
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

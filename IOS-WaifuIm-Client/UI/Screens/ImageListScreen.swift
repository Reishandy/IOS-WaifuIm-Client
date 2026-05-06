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
	
	@State private var isFilterSheetPresented: Bool = false
	@State private var isFetchingCooldown: Bool = false
	@State private var scrollPosition: ScrollPosition = ScrollPosition()
	@State private var isAccountShown: Bool = false
	@State private var isSingleColumn: Bool = false
	
	private var isRandomOrder: Bool {
		appManager.filterState.orderBy == .random
	}
	
	private var subtitleText: String {
		if isRandomOrder {
			return "A Collection of waifu images"
		} else if appManager.hasNsfwResult {
			return "Hmmm... NSFW..."
		} else {
			return "Showing you \(appManager.imageCount) filtered images"
		}
	}
	
	var body: some View {
		@Bindable var appManager = appManager
		
		VStack {
			if appManager.hasNsfwResult {
				EmptyStateView(
					iconName: "18.circle",
					title: "Hmmm",
					description: "We have the images but it is NSFW...",
					actionButtonText: "Include NSFW Images"
				) {
					appManager.filterState.isNsfw = .all
					populate(isFresh: true)
				}
			} else if appManager.imageResponses.isEmpty {
				if appManager.isFetchingImages {
					ProgressView()
				} else {
					EmptyStateView(
						iconName: "photo.badge.magnifyingglass",
						title: "No Images Here",
						description: "We can't find any images with that filter criteria.",
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
					isRandomOrder: isRandomOrder,
					hasMoreImage: appManager.hasMoreImage,
					populate: { isFresh in
						self.populate(isFresh: isFresh)
					},
					isSingleColumn: isSingleColumn,
					scrollPosition: $scrollPosition
				)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.navigationTitle("Waifu.im")
		.navigationSubtitle(subtitleText)
		.toolbar {
			
			ToolbarItem(placement: .topBarTrailing) {
				if isRandomOrder {
					Button {
						populate(isFresh: true)
					} label: {
						Image(systemName: "arrow.triangle.2.circlepath")
					}
				} else {
					Button {
						withAnimation(.easeInOut) {
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
						ImageItemView(imageUrl: avatarUrl, width: 35, height: 35)
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
					value: Screen.tagScreen
				) {
					Image(systemName: "tag")
				}
				.padding(.trailing, -20)
			}
			
			ToolbarItem(placement: .bottomBar) {
				NavigationLink(
					value: Screen.artistScreen
				) {
					Image(systemName: "person.2")
				}
				.padding(.trailing, appManager.albumResponses != nil ? -16 : 8)
			}
			
			if appManager.albumResponses != nil {
				ToolbarItem(placement: .bottomBar) {
					NavigationLink(
						value: Screen.albumScreen
					) {
						Image(systemName: "folder")
					}
					.padding(.trailing, 10)
					.transition(.opacity)
				}
			}
			
			ToolbarSpacer(placement: .bottomBar)
			
			ToolbarItem(placement: .bottomBar) {
				Button {
					isSingleColumn.toggle()
				} label: {
					Image(systemName: isSingleColumn ? "rectangle.3.group" : "rectangle.portrait")
						.contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .nonRepeating))
				}
				.padding(.trailing, -20)
			}
			
			ToolbarItem(placement: .bottomBar) {
				Button {
					isFilterSheetPresented = true
				} label: {
					Image(systemName: "line.3.horizontal.decrease")
				}
				.padding(.trailing, 10)
				.matchedTransitionSource(id: "filterSheetSource", in: imageListScreenNameSpace)
			}
		}
		.onChange(of: appManager.imageResponses.isEmpty) {
			withAnimation(.easeInOut) {
				scrollPosition.scrollTo(edge: .top)
			}
		}
		.sheet(isPresented: $isFilterSheetPresented) {
			FilterSheetView(
				filterState: $appManager.filterState,
				onApplyPress: {
					isFilterSheetPresented = false
					populate(isFresh: true)
				},
				onCancelPress: {
					isFilterSheetPresented = false
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
				populate(isFresh: true)
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

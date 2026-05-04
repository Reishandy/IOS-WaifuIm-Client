//
//  TagScreen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct TagScreen: View {
	@Environment(AppManager.self) private var appManager
	@Environment(RouterManager.self) private var routerManager
	
	@State private var searchText = ""
	
	private var filteredTags: [ResponseTag] {
		if searchText.isEmpty {
			return appManager.tagResponses
		} else {
			return appManager.tagResponses.filter { tag in
				tag.name.localizedCaseInsensitiveContains(searchText) ||
				tag.description.localizedCaseInsensitiveContains(searchText)
			}
		}
	}
	
    var body: some View {
		GeometryReader { geometry in
			let screenWidth = geometry.size.width
			
			ScrollView {
				LazyVGrid(
					columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: screenWidth > 1000 ? 3 : screenWidth > 500 ? 2 : 1),
					spacing: 4
				) {
					ForEach(filteredTags) { tag in
						TagCardView(responseTag: tag)
							.onTapGesture {
								routerManager.reset()
								
								Task {
									await appManager.fetchOnlyTagOrArtist(slug: tag.slug)
								}
							}
							.transition(.scale(0.8).combined(with: .opacity))
					}
				}
				.padding(10)
			}
		}
		.navigationTitle("All Tags")
		.toolbarTitleDisplayMode(.inline)
		.searchable(text: $searchText, placement: .toolbar, prompt: "Search tags...")
		.animation(.spring, value: filteredTags)
    }
}

#Preview {
	NavigationStack {
		TagScreen()
			.environment(AppManager())
			.environment(RouterManager())
	}
}

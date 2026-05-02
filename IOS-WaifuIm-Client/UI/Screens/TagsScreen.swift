//
//  TagsScreen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct TagsScreen: View {
	@Environment(AppManager.self) private var appManager
	@Environment(\.dismiss) var dismiss
	
	let onTagTap: (String) -> Void
	
	@State private var searchText = ""
	
	private var filteredTags: [ResponseTag] {
		if searchText.isEmpty {
			return appManager.fetchedTagResponses
		} else {
			return appManager.fetchedTagResponses.filter { tag in
				tag.name.localizedCaseInsensitiveContains(searchText) ||
				tag.description.localizedCaseInsensitiveContains(searchText)
			}
		}
	}
	
    var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(filteredTags) { tag in
					TagCardView(responseTag: tag)
						.onTapGesture {
							dismiss()
							onTagTap(tag.slug)
						}
				}
			}
		}
		.padding(10)
		.navigationTitle("All Tags")
		.toolbarTitleDisplayMode(.inline)
		.searchable(text: $searchText, placement: .toolbar, prompt: "Search tags...")
    }
}

#Preview {
	NavigationStack {
		TagsScreen(onTagTap: { _ in })
			.environment(AppManager())
	}
}

//
//  AlbumScreen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

import SwiftUI

struct AlbumScreen: View {
	@Environment(AppManager.self) private var appManager
	
	@State private var searchText = ""
	
	private var filteredAlbums: [ResponseAlbum] {
		if searchText.isEmpty {
			return appManager.fetchedAlbumResponses ?? []
		} else {
			return appManager.fetchedAlbumResponses?.filter { album in
				album.name.localizedCaseInsensitiveContains(searchText) ||
				album.description.localizedCaseInsensitiveContains(searchText)
			} ?? []
		}
	}
	
	var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(filteredAlbums) { album in
					AlbumCardView(
						responseAlbum: album,
						onEditTap: { id in },
						onDeleteTap: { id in }
					)
				}
			}
		}
		.padding(10)
		.navigationTitle("All Albums")
		.toolbarTitleDisplayMode(.inline)
		.searchable(text: $searchText, placement: .toolbar, prompt: "Search albums...")
	}
}

#Preview {
    AlbumScreen()
		.environment(AppManager())
}

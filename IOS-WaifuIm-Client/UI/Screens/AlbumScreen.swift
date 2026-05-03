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
	@State private var isFormPresented: Bool = false
	
	private var filteredAlbums: [ResponseAlbum] {
		if searchText.isEmpty {
			return appManager.albumResponses ?? []
		} else {
			return appManager.albumResponses?.filter { album in
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
						onEditTap: { albumId, name, description in
							Task {
								await appManager.updateAlbum(
									albumId: albumId,
									name: name,
									description: description
								)
							}
						},
						onDeleteTap: { albumId in
							Task {
								await appManager.deleteAlbum(albumId: albumId)
							}
						}
					)
					.transition(.scale(0.8).combined(with: .opacity))
				}
			}
			.padding(10)
		}
		.navigationTitle("All Albums")
		.toolbarTitleDisplayMode(.inline)
		.searchable(text: $searchText, placement: .toolbar, prompt: "Search albums...")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					isFormPresented = true
				} label: {
					Image(systemName: "plus")
				}
				.popover(isPresented: $isFormPresented) {
					AlbumFormView(
						onSaveTap: { name, description in
							Task {
								await appManager.createAlbum(name: name, description: description)
							}
						}
					)
					.presentationCompactAdaptation(.popover)
				}
			}
		}
		.animation(.spring, value: filteredAlbums)
	}
}

#Preview {
	NavigationStack {
		AlbumScreen()
			.environment(AppManager())
	}
}

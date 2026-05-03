//
//  AlbumScreen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

import SwiftUI

struct AlbumScreen: View {
	@Environment(AppManager.self) private var appManager
	@Environment(\.dismiss) var dismiss
	
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
		@Bindable var appManager = appManager
		
		ScrollView {
			LazyVStack {
				ForEach(filteredAlbums) { album in
					NavigationLink(
						value: Screen.albumImageScreen(albumId: album.id)
					) {
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
					.buttonStyle(.plain)
				}
			}
			.padding(10)
		}
		.task {
			await appManager.fetchAlbums()
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
		.alert(
			"Oops!",
			isPresented: $appManager.showError,
			presenting: appManager.error
		) { _ in
			Button("OK", role: .cancel) {
				dismiss()
			}
		} message: { error in
			Text(error.localizedDescription)
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

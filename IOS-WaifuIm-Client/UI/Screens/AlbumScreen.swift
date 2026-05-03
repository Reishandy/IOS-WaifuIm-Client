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
	@State private var formContext: AlbumFormContext? = nil
	
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
								formContext = AlbumFormContext(
									editId: albumId,
									name: name,
									description: description
								)
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
					formContext = AlbumFormContext(editId: nil, name: "", description: "")
				} label: {
					Image(systemName: "plus")
				}
			}
		}
		.sheet(item: $formContext) { context in
			AlbumFormView(
				name: context.name,
				description: context.description,
				onSaveTap: { name, description in
					Task {
						if let id = context.editId {
							await appManager.updateAlbum(
								albumId: id,
								name: name,
								description: description
							)
						} else {
							await appManager.createAlbum(name: name, description: description)
						}
						
						formContext = nil
					}
				}
			)
			.presentationDetents([.medium])
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

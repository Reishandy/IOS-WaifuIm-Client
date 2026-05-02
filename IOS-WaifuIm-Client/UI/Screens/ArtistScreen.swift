//
//  ArtistScreen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct ArtistScreen: View {
	@Environment(AppManager.self) private var appManager
	@Environment(\.dismiss) var dismiss
	
	let onArtistTap: (String) -> Void
	
	@State private var searchText = ""
	
	private var filteredArtists: [ResponseArtist] {
		if searchText.isEmpty {
			return appManager.fetchedArtistResponses
		} else {
			return appManager.fetchedArtistResponses.filter { artist in
				artist.name.localizedCaseInsensitiveContains(searchText)
			}
		}
	}
	
	var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(filteredArtists) { artist in
					ArtistCardView(responseArtist: artist)
						.onTapGesture {
							dismiss()
							onArtistTap(String(artist.id))
						}
						.transition(.scale(0.8).combined(with: .opacity))
				}
			}
			.padding(10)
		}
		.navigationTitle("All Artists")
		.toolbarTitleDisplayMode(.inline)
		.searchable(text: $searchText, placement: .toolbar, prompt: "Search artists...")
		.animation(.spring, value: filteredArtists)
	}
}

#Preview {
	NavigationStack {
		ArtistScreen(onArtistTap: { _ in })
			.environment(AppManager())
	}
}

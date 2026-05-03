//
//  AlbumImageListScreen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 03/05/26.
//

import SwiftUI

struct AlbumImageListScreen: View {
	@Environment(AppManager.self) private var appManager
	
	let albumId: Int
	
	@State private var imageResponses: [ResponseImage] = []
	@State private var currentPage: Int = 1
	@State private var hasNextPage: Bool = false
	@State private var scrollPosition: ScrollPosition = ScrollPosition()
	
    var body: some View {
		@Bindable var appManager = appManager
		
		VStack {
			if imageResponses.isEmpty {
				if appManager.isFetchingImagasAlbum {
					ProgressView()
				} else {
					EmptyStateView(
						iconName: "photo.badge.magnifyingglass",
						title: "No Images",
						description: "No Images in this album, add some!"
					)
				}
			} else {
				ImageListView(
					imageResponses: imageResponses,
					isLoading: appManager.isFetchingImagasAlbum,
					isRandomOrder: false,
					hasMoreImage: hasNextPage,
					populate: { isFresh in
						populate(isFresh: isFresh)
					},
					scrollPosition: $scrollPosition
				)
			}
		}
		.task {
			populate(isFresh: true)
		}
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					withAnimation {
						scrollPosition.scrollTo(edge: .top)
					}
				} label: {
					Image(systemName: "arrow.up")
				}
			}
		}
    }
	
	private func populate(isFresh: Bool) {
		Task {
			let response = await appManager.fetchAlbumImages(
				albumId: albumId, currentPage: isFresh ? 1 : currentPage
			)
			
			if isFresh {
				self.imageResponses = response.imageResponses
			} else {
				self.imageResponses += response.imageResponses
			}
			
			self.hasNextPage = response.hasNextPage
			self.currentPage += 1
		}
	}
}

#Preview {
    AlbumImageListScreen(albumId: 1)
}

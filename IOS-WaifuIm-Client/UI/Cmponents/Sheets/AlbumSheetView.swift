//
//  AlbumSheetView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct AlbumSheetView: View {
	@Environment(AppManager.self) private var appManager
	
	let imageInAlbumsIds: Set<Int>
	let onAlbumTap: (Int) -> Void
	
	@State private var isFormPresented: Bool = false
	
    var body: some View {
		ScrollView {
			Button {
				isFormPresented = true
			} label: {
				Text("Create New Album")
					.padding(6)
					.frame(maxWidth: .infinity)
			}
			.buttonStyle(.glass)
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
			.padding([.top, .horizontal], 10)
			
			if let albums = appManager.albumResponses {
				LazyVStack {
					ForEach(albums) { album in
						AlbumCardView(
							responseAlbum: album,
							isSelected: imageInAlbumsIds.contains(album.id),
							showImageCount: false
						)
						.transition(.scale(0.8).combined(with: .opacity))
						.onTapGesture {
							onAlbumTap(album.id)
						}
					}
				}
				.padding(10)
				.animation(.spring, value: albums)
			}
		}
    }
}

#Preview {
	AlbumSheetView(imageInAlbumsIds: [], onAlbumTap: { _ in })
		.environment(AppManager())
}

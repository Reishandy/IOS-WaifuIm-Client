//
//  AlbumCardView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

import SwiftUI

struct AlbumCardView: View {
	let responseAlbum: ResponseAlbum
	let onEditTap: (String, String, String) -> Void
	let onDeleteTap: (String) -> Void
	
	@State private var isConfirmaionPresented: Bool = false
	@State private var isFormPresented: Bool = false
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack(alignment: .center) {
				Text(responseAlbum.name)
					.font(.title)
					.bold()
				
				Spacer()
				
				if !responseAlbum.isDefault {
					Button {
						isFormPresented = true
					} label: {
						Image(systemName: "pencil")
							.font(.title2)
							.tint(.gray)
							.padding(.horizontal, 12)
							.padding(.vertical, 8)
							.background(Color(uiColor: .tertiarySystemFill))
							.clipShape(RoundedRectangle(cornerRadius: 8))
					}
					.popover(isPresented: $isFormPresented) {
						AlbumFormView(
							name: responseAlbum.name,
							description: responseAlbum.description,
							onSaveTap: { name, description in
								onEditTap(String(responseAlbum.id), name, description)
							}
						)
						.presentationCompactAdaptation(.popover)
					}
					
					
					Button {
						isConfirmaionPresented = true
					} label: {
						Image(systemName: "trash")
							.tint(.red)
							.padding(.horizontal, 12)
							.padding(.vertical, 8)
							.background(Color(uiColor: .tertiarySystemFill))
							.clipShape(RoundedRectangle(cornerRadius: 8))
					}
					.confirmationDialog(
						"Delete",
						isPresented: $isConfirmaionPresented
					) {
						Button("Delete", role: .destructive) {
							onDeleteTap(String(responseAlbum.id))
						}
						.buttonStyle(.bordered)
					} message: {
						Text("Are you sure you want to delete this album?")
					}
				}
			}
			
			HStack {
				Image(systemName: "photo")
					.font(.subheadline)
					.opacity(0.5)
				
				Text("\(responseAlbum.imageCount)")
					.font(.subheadline)
					.opacity(0.5)
			}
			
			if !responseAlbum.description.isEmpty {
				Text(responseAlbum.description)
					.opacity(0.6)
			}
		}
		.padding(12)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(Color(uiColor: .tertiarySystemFill))
		.clipShape(RoundedRectangle(cornerRadius: 8))
	}
}

#Preview {
	AlbumCardView(
		responseAlbum: ResponseAlbum.mocks.last!,
		onEditTap: { _, _, _ in },
		onDeleteTap: { _ in }
	)
}

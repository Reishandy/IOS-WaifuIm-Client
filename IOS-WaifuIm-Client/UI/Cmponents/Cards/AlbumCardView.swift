//
//  AlbumCardView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

import SwiftUI

struct AlbumCardView: View {
	let responseAlbum: ResponseAlbum
	var onEditTap: ((Int, String, String) -> Void)? = nil
	var onDeleteTap: ((Int) -> Void)? = nil
	var isSelected: Bool = false
	var showImageCount: Bool = true
	
	@State private var isConfirmaionPresented: Bool = false
	
	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			HStack(alignment: .center) {
				VStack(alignment: .leading) {
					Text(responseAlbum.name)
						.font(.title)
						.bold()
					
					if showImageCount {
						HStack {
							Image(systemName: "photo")
								.font(.subheadline)
								.opacity(0.5)
							
							Text("\(responseAlbum.imageCount)")
								.font(.subheadline)
								.opacity(0.5)
						}
					}
				}
				
				Spacer()
				
				if isSelected {
					Image(systemName: "checkmark")
						.font(.title2)
						.foregroundStyle(.primary)
						.transition(.scale(0.8).combined(with: .opacity))
				}
				
				if !responseAlbum.isDefault {
					if let onEditTap = onEditTap {
						Button {
							onEditTap(responseAlbum.id, responseAlbum.name, responseAlbum.description)
						} label: {
							Image(systemName: "pencil")
								.font(.title2)
								.foregroundStyle(.gray)
								.padding(.horizontal, 12)
								.padding(.vertical, 8)
								.background(Color(uiColor: .tertiarySystemFill))
								.clipShape(RoundedRectangle(cornerRadius: 8))
						}
					}
					
					if let onDeleteTap = onDeleteTap {
						Button {
							isConfirmaionPresented = true
						} label: {
							Image(systemName: "trash")
								.foregroundStyle(.red)
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
								onDeleteTap(responseAlbum.id)
							}
							.buttonStyle(.bordered)
						} message: {
							Text("Are you sure you want to delete this album?")
						}
					}
				}
			}
			
			if !responseAlbum.description.isEmpty {
				Text(responseAlbum.description)
					.opacity(0.6)
			}
			
			Spacer()
		}
		.padding(12)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
		.background(Color(uiColor: .tertiarySystemFill))
		.clipShape(RoundedRectangle(cornerRadius: 8))
		.animation(.spring, value: isSelected)
	}
}

#Preview {
	AlbumCardView(
		responseAlbum: ResponseAlbum.mocks.last!,
		onEditTap: { _, _, _ in },
		onDeleteTap: { _ in }
	)
}

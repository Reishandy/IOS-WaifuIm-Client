//
//  AlbumFormView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 03/05/26.
//

import SwiftUI

struct AlbumFormView: View {
	@Environment(\.dismiss) var dismiss
	
	let onSaveTap: (String, String) -> Void
	
	@State private var nameInput: String = ""
	@State private var descriptionInput: String = ""
	
	init(
		name: String = "",
		description: String = "",
		onSaveTap: @escaping (String, String) -> Void
	) {
		self.nameInput = name
		self.descriptionInput = description
		self.onSaveTap = onSaveTap
	}
	
    var body: some View {
		VStack(spacing: 20) {
			VStack(alignment: .leading, spacing: 12) {
				Text("Name")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				TextField("Album Name", text: $nameInput)
					.padding(.horizontal, 12)
					.padding(.vertical, 8)
					.background(Color(uiColor: .tertiarySystemFill))
					.clipShape(RoundedRectangle(cornerRadius: 8))
			}
			
			VStack(alignment: .leading, spacing: 12) {
				Text("Description")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				TextField("Album Description...", text: $descriptionInput, axis: .vertical)
					.lineLimit(3...10)
					.padding(.horizontal, 12)
					.padding(.vertical, 8)
					.background(Color(uiColor: .tertiarySystemFill))
					.clipShape(RoundedRectangle(cornerRadius: 8))
			}
			
			HStack {
				Button {
					dismiss()
				} label: {
					Text("Cancel")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.glass)
				
				Button {
					dismiss()
					onSaveTap(nameInput, descriptionInput)
					nameInput = ""
					descriptionInput = ""
				} label: {
					Text("Save")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.glassProminent)
			}
		}
		.padding(.horizontal, 30)
		.padding(.vertical, 10)
		.frame(width: 400, height: 300)
    }
}

#Preview {
	AlbumFormView(onSaveTap: { _, _ in })
		.border(.blue)
}

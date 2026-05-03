//
//  InfoSheetView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct InfoSheetView: View {
	@Environment(AppManager.self) private var appManager
	
	let imageResponse: ResponseImage
	let onTagTap: (String) -> Void
	let onArtistTap: (String) -> Void
	let onFavoriteTap: () -> Void
	let isFavorited: Bool
	
	@State private var isColorCopied: Bool = false
	
	private var realTags: [ResponseTag] {
		let targetTagIds = Set(imageResponse.tags.map { $0.id })
		
		return appManager.tagResponses.filter { targetTagIds.contains($0.id) }
	}
	
	private var realArtists: [ResponseArtist] {
		let targetArtistIds = Set(imageResponse.artists.map { $0.id })
		
		return appManager.artistResponses.filter { targetArtistIds.contains($0.id) }
	}
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 10) {
				HStack(alignment: .center) {
					Text("Image #\(String(imageResponse.id))")
						.font(.title)
						.bold()
					
					Spacer()
					
					Button {
						onFavoriteTap()
					} label: {
						HStack(alignment: .center) {
							Image(systemName: isFavorited ? "heart.fill" : "heart")
								.font(.title)
								.foregroundStyle(isFavorited ? .red : .primary)
							
							Text(String(imageResponse.favorites))
								.font(.title3)
						}
					}
					.buttonStyle(.plain)
				}
				.frame(maxHeight: .infinity, alignment: .center)
				
				if let source = imageResponse.source {
					Link(destination: URL(string: source)!) {
						Text(source)
							.font(.title3)
							.tint(.primary.opacity(0.6))
							.lineLimit(1)
							.truncationMode(.middle)
					}
				}
				
				Divider()
				
				VStack(alignment: .leading, spacing: 10) {
					LabeledContent("Uploaded", value: imageResponse.uploadedAt.split(separator: "T").first ?? "")
					
					Divider()
					
					LabeledContent("Size") {
						Text(Int64(imageResponse.byteSize), format: .byteCount(style: .file))
					}
					
					Divider()
					
					LabeledContent("Dimensions", value: "\(imageResponse.width) x \(imageResponse.height)")
					
					Divider()
					
					LabeledContent("Dominant color", value: isColorCopied ? "Copied" : imageResponse.dominantColor)
						.onTapGesture {
							withAnimation {
								UIPasteboard.general.string = imageResponse.dominantColor
								isColorCopied = true
							}
							
							
							DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
								withAnimation {
									isColorCopied = false
								}
							}
						}
					
					if let status = imageResponse.reviewStatus {
						Divider()
						
						LabeledContent("Status", value: status)
					}
				}
				.padding(.horizontal, 12)
				.padding(.vertical, 8)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(Color(uiColor: .tertiarySystemFill))
				.clipShape(RoundedRectangle(cornerRadius: 8))
				
				Divider()
				
				Text("Tags")
					.font(.title3)
					.bold()
				
				
				if realTags.isEmpty {
					EmptyStateView(
						iconName: "tag.slash",
						title: "No Tags",
						description: "No tags are associated with this image",
						isSmall: true
					)
				} else {
					ScrollView(.horizontal) {
						HStack {
							ForEach(realTags) { tag in
								TagCardView(responseTag: tag)
									.frame(maxWidth: 200)
									.onTapGesture {
										onTagTap(tag.slug)
									}
							}
						}
					}
					.scrollIndicators(.hidden)
				}
				
				Text("Artists")
					.font(.title3)
					.bold()
				
				if realArtists.isEmpty {
					EmptyStateView(
						iconName: "person.2.slash",
						title: "No Artists",
						description: "No artists are associated with this image",
						isSmall: true
					)
				} else {
					VStack {
						ForEach(realArtists) { artist in
							ArtistCardView(responseArtist: artist)
								.onTapGesture {
									onArtistTap(String(artist.id))
								}
						}
					}
				}
			}
			.padding(24)
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
}

#Preview {
	@Previewable @State var isSheetPresented: Bool = true
	@Previewable @State var currentSheetDetent: Bool = true
	
	VStack {
		Button("toggle sheet") {
			isSheetPresented = true
		}
		.buttonStyle(.glassProminent)
	}
	.sheet(isPresented: $isSheetPresented) {
		InfoSheetView(
			imageResponse: ResponseImage.mock,
			onTagTap: {	_ in },
			onArtistTap: { _ in },
			onFavoriteTap: {},
			isFavorited: false
		)
		.presentationDetents([.medium])
		.environment(AppManager())
	}
	
}

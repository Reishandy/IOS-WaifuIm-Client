//
//  ArtistCardView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

import SwiftUI

struct ArtistCardView: View {
	var responseArtist: ResponseArtist
	
    var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Text(responseArtist.name)
					.font(.title2)
					.bold()
				
				Spacer()
				
				Text("\(responseArtist.imageCount)")
					.font(.subheadline)
					.opacity(0.5)
				
				Image(systemName: "photo")
					.font(.subheadline)
					.opacity(0.5)
			}
			
			Divider()
			
			VStack {
				if let patreon = responseArtist.patreon {
					LabeledContent("Patreon") {
						Link(destination: URL(string: patreon)!) {
							Text(patreon)
								.lineLimit(1)
								.truncationMode(.middle)
								.tint(.primary.opacity(0.6))
						}
					}
				}
				
				if let pixiv = responseArtist.pixiv {
					LabeledContent("Pixiv") {
						Link(destination: URL(string: pixiv)!) {
							Text(pixiv)
								.lineLimit(1)
								.truncationMode(.middle)
								.tint(.primary.opacity(0.6))
						}
					}
				}
				
				if let twitter = responseArtist.twitter {
					LabeledContent("Twitter") {
						Link(destination: URL(string: twitter)!) {
							Text(twitter)
								.lineLimit(1)
								.truncationMode(.middle)
								.tint(.primary.opacity(0.6))
						}
					}
				}
				
				if let devianArt = responseArtist.devianArt {
					LabeledContent("DevianArt") {
						Link(destination: URL(string: devianArt)!) {
							Text(devianArt)
								.lineLimit(1)
								.truncationMode(.middle)
								.tint(.primary.opacity(0.6))
						}
					}
				}
			}
		}
		.padding(12)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(Color(uiColor: .tertiarySystemFill))
		.clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
	ArtistCardView(responseArtist: ResponseArtist.mocks.first!)
}

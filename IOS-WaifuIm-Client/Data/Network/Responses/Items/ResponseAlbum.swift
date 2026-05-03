//
//  ResponseAlbum.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

nonisolated struct ResponseAlbum: Decodable, Identifiable, Equatable, Hashable {
	let id: Int
	let name: String
	let description: String
	let isDefault: Bool
	let userId: Int
	let imageCount: Int
	
	static var mocks: [ResponseAlbum] = [
		ResponseAlbum(
			id: 1,
			name: "My Favorites",
			description: "A collection of my absolute favorite artworks.",
			isDefault: true,
			userId: 101,
			imageCount: 42
		),
		ResponseAlbum(
			id: 2,
			name: "Desktop Wallpapers",
			description: "High resolution landscape images for my Mac.",
			isDefault: false,
			userId: 101,
			imageCount: 15
		),
		ResponseAlbum(
			id: 3,
			name: "Reference Poses",
			description: "Anatomy practice and dynamic lighting references.",
			isDefault: false,
			userId: 101,
			imageCount: 128
		),
		ResponseAlbum(
			id: 4,
			name: "Work in Progress",
			description: "Short description.",
			isDefault: false,
			userId: 101,
			imageCount: 3
		),
		ResponseAlbum(
			id: 5,
			name: "Very Long Album Name That Might Wrap On Some Smaller Devices",
			description: "This is a very long description intended to test how the UI handles overflow and multiline text rendering within the album cell components.",
			isDefault: false,
			userId: 101,
			imageCount: 0
		)
	]
}

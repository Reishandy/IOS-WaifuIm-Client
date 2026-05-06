//
//  ResponseImage.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import Foundation

nonisolated struct ResponseImage: Decodable, Identifiable, Equatable, Hashable {
	let id: Int
	let perceptualHash: String
	let dominantColor: String
	let source: String?
	let artists: [ResponseArtist]
	let uploaderId: Int?
	let uploadedAt: String
	let isNsfw: Bool
	let isAnimated: Bool
	let width: Int
	let height: Int
	let byteSize: Int
	let url: String
	let tags: [ResponseTag]
	let reviewStatus: String?
	let favorites: Int
	let likedAt: String?
	let addedToAlbumAt: String?
	var albums: [ResponseAlbum]
	
	static let mock: ResponseImage = ResponseImage(
		id: 3386,
		perceptualHash: "f998c2278ed4134f",
		dominantColor: "#FF746C",
		source: "https://reishandy.id",
		artists: [ResponseArtist.mocks.first!],
		uploaderId: 123,
		uploadedAt: "2021-11-02T11:16:19.048684Z",
		isNsfw: false,
		isAnimated: false,
		width: 792,
		height: 729,
		byteSize: 48956,
		url: "https://github.com/Reishandy/Reishandy/blob/85b5bd0ef00735d277eaf41db3f28a5eb6e2c63a/repo/michiru_profile.webp?raw=true",
		tags: ResponseTag.mocks,
		reviewStatus: "Accepted",
		favorites: 143,
		likedAt: nil,
		addedToAlbumAt: nil,
		albums: [ResponseAlbum.mocks.first!]
	)
}

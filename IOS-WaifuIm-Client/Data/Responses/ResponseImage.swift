//
//  ResponseImage.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import Foundation

nonisolated struct ResponseImage: Decodable, Identifiable, Equatable {
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
	let likedAt: Date?
	let addedToAlbumAt: Date?
	let albums: [ResponseAlbum]
}

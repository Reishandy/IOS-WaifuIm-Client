//
//  ResponseImage.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

struct ResponseImage {
	let id: String
	let perceptualHash: String
	let dominantColor: String
	let source: String?
	let artists: [ResponseArtist]
	let uploaderId: String?
	let uploadedAt: String
	let isNsfw: String
	let isAnimated: String
	let width: String
	let height: String
	let byteSize: String
	let url: String
	let tags: [ResponseTag]
	let reviewStatus: String?
	let favorites: String
	let likedAt: String?
	let addedToAlbumAt: String?
	let albums: [ResponseAlbum]
}

//
//  ResponseArtist.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

nonisolated struct ResponseArtist: Decodable, Identifiable, Equatable, APIResource {
	let id: Int
	let name: String
	let patreon: String?
	let pixiv: String?
	let twitter: String?
	let devianArt: String?
	let reviewStatus: String?
	let creatorId: Int?
	let imageCount: Int
	
	static var path: APIPath { .artists }
}

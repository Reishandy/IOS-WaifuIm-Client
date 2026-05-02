//
//  ResponseArtist.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

nonisolated struct ResponseArtist: Decodable, Identifiable, Equatable, APIResponse, TokenDisplayable {
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
	var token: String {	String(self.id) }
	var tokenTitle: String { self.name }
	var tokenDescription: String? { nil }
	
	static var mocks: [ResponseArtist] = [
		ResponseArtist(
			id: 1,
			name: "Rei",
			patreon: "https://reishandy.id",
			pixiv: "https://reishandy.id",
			twitter: "https://reishandy.id",
			devianArt: "https://reishandy.id",
			reviewStatus: "Accepted",
			creatorId: nil,
			imageCount: 1
		),
		ResponseArtist(
			id: 2,
			name: "F",
			patreon: "https://reishandy.id",
			pixiv: nil,
			twitter: nil,
			devianArt: nil,
			reviewStatus: "Accepted",
			creatorId: nil,
			imageCount: 21
		),
		ResponseArtist(
			id: 3,
			name: "Some Long Ass Name that",
			patreon: "https://reishandy.id",
			pixiv: "https://reishandy.id",
			twitter: "https://reishandy.id",
			devianArt: "https://reishandy.id",
			reviewStatus: "Pending",
			creatorId: nil,
			imageCount: 13
		),
		ResponseArtist(
			id: 4,
			name: "Blabla",
			patreon: nil,
			pixiv: nil,
			twitter: nil,
			devianArt: nil,
			reviewStatus: "Accepted",
			creatorId: nil,
			imageCount: 1231
		),
		ResponseArtist(
			id: 5,
			name: "Ayam",
			patreon: "https://reishandy.id",
			pixiv: nil,
			twitter: "https://reishandy.id",
			devianArt: nil,
			reviewStatus: "Pending",
			creatorId: nil,
			imageCount: 13
		)
	]
}

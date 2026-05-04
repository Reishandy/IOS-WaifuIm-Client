//
//  ResponseTag.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

nonisolated struct ResponseTag: Decodable, Identifiable, Equatable, Hashable, TokenDisplayable {
	let id: Int
	let name: String
	let slug: String
	let description: String
	let reviewStatus: String?
	let creatorId: Int?
	let imageCount: Int
	
	var token: String {	self.slug }
	var tokenTitle: String { self.name }
	var tokenDescription: String? { self.description }
	
	static var mocks: [ResponseTag] = [
		ResponseTag(
			id: 1,
			name: "Waifu",
			slug: "waifu",
			description: "This is a description of the tag",
			reviewStatus: "Accepted",
			creatorId: nil,
			imageCount: 3144
		),
		ResponseTag(
			id: 2,
			name: "Anime",
			slug: "anime",
			description: "This is a description of the tag",
			reviewStatus: "Pending",
			creatorId: nil,
			imageCount: 1413
		),
		ResponseTag(
			id: 3,
			name: "Ecchi",
			slug: "ecchi",
			description: "This is a description of the tag",
			reviewStatus: "Accepted",
			creatorId: nil,
			imageCount: 5555
		),
		ResponseTag(
			id: 4,
			name: "Ero",
			slug: "ero",
			description: "This is a description of the tag",
			reviewStatus: "Pending",
			creatorId: nil,
			imageCount: 111
		),
		ResponseTag(
			id: 5,
			name: "Long Ass Tag",
			slug: "long-ass-tag",
			description: "This is a description of the tag This is a description of the tag This is a description of the tag",
			reviewStatus: "Accepted",
			creatorId: nil,
			imageCount: 1111
		)
	]
}

//
//  ResponseTag.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

nonisolated struct ResponseTag: Decodable, Identifiable {
	let id: Int
	let name: String
	let slug: String
	let description: String
	let reviewStatus: String?
	let creatorId: Int?
	let imageCount: Int
}

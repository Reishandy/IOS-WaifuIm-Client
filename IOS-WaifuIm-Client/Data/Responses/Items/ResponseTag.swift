//
//  ResponseTag.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

nonisolated struct ResponseTag: Decodable, Identifiable, Equatable, APIResource, TokenDisplayable {
	let id: Int
	let name: String
	let slug: String
	let description: String
	let reviewStatus: String?
	let creatorId: Int?
	let imageCount: Int
	
	static var path: APIPath { .tags }
	var token: String {	self.slug }
	var tokenTitle: String { self.name }
	var tokenDescription: String? { self.description }
}

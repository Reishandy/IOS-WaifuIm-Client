//
//  ResponseAlbum.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

nonisolated struct ResponseAlbum: Decodable, Identifiable, Equatable {
	let id: Int
	let name: String
	let description: String
	let isDefault: Bool
	let userId: Int
	let imageCount: Int
}

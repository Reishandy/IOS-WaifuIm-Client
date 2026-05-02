//
//  ResponseProfile.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

nonisolated struct ResponseProfile: Decodable {
	var id: Int
	var name: String
	var discordId: String
	var avatarUrl: String?
	var role: String
	var isBlacklisted: Bool
	var blacklistReason: String?
	var requestCount: Int
	var apiKeyRequestCount: Int
	var jwtRequestCount: Int
	var uploadedImageCount: Int
	var albumImageCount: Int
	
	static let mock: ResponseProfile = ResponseProfile(
		id: 1,
		name: "Ruxury",
		discordId: "ruxury_nyaa",
		avatarUrl: "https://github.com/Reishandy/Reishandy/blob/85b5bd0ef00735d277eaf41db3f28a5eb6e2c63a/repo/michiru_profile.webp?raw=true",
		role: "User",
		isBlacklisted: false,
		blacklistReason: nil,
		requestCount: 0,
		apiKeyRequestCount: 0,
		jwtRequestCount: 0,
		uploadedImageCount: 0,
		albumImageCount: 0
	)
}

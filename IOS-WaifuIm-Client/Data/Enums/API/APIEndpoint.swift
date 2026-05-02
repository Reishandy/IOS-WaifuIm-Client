//
//  APIEndpoint.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

nonisolated enum APIEndpoint<Response: Decodable> {
	case images
	case tags
	case artists
	case albums(userId: Int)
	case profile
	
	var path: String {
		switch self {
		case .images: return "images"
		case .tags: return "tags"
		case .artists: return "artists"
		case .profile: return "users/me"
		case .albums(let id): return "users/\(id)/albums"
		}
	}
}

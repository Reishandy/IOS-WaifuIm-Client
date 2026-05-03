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
	
	var value: (method: APIMethod, path: String) {
		switch self {
		case .images: return (.get, "images")
		case .tags: return (.get, "tags")
		case .artists: return (.get, "artists")
		case .profile: return (.get, "users/me")
		case .albums(let id): return (.get, "users/\(id)/albums")
		}
	}
}

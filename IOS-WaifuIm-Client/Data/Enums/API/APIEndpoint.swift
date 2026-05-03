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
	case profile
	case albums(userId: Int)
	case albumCreate(userId: Int)
	case albumUpdate(userId: Int, albumId: Int)
	case albumDelete(userId: Int, albumId: Int)
	
	var value: (method: APIMethod, path: String) {
		switch self {
		case .images: return (.get, "images")
		case .tags: return (.get, "tags")
		case .artists: return (.get, "artists")
		case .profile: return (.get, "users/me")
		case .albums(let userId): return (.get, "users/\(String(userId))/albums")
		case .albumCreate(let userId): return (.post, "users/\(String(userId))/albums")
		case .albumUpdate(let userId, let albumId): return (.patch, "users/\(String(userId))/albums/\(String(albumId))")
		case .albumDelete(let userId, let albumId): return (.delete, "users/\(String(userId))/albums/\(String(albumId))")
		}
	}
}

//
//  APIEndpoint.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

nonisolated enum APIEndpoint<Response: Decodable> {
	case images
	case image(imageId: Int)
	case tags
	case artists
	case profile
	case albums(userId: Int)
	case albumImages(userId: Int, albumId: Int)
	case albumCreate(userId: Int)
	case albumUpdate(userId: Int, albumId: Int)
	case albumDelete(userId: Int, albumId: Int)
	case addImageToAlbum(userId: Int, albumId: Int, imageId: Int)
	case deleteImageToAlbum(userId: Int, albumId: Int, imageId: Int)
	
	var value: (method: APIMethod, path: String) {
		switch self {
		case .images: return (.get, "images")
		case .image(let imageId): return (.get, "images/\(String(imageId))")
		case .tags: return (.get, "tags")
		case .artists: return (.get, "artists")
		case .profile: return (.get, "users/me")
		case .albums(let userId): return (.get, "users/\(String(userId))/albums")
		case .albumImages(let userId, let albumId): return (.get, "users/\(String(userId))/albums/\(String(albumId))/images")
		case .albumCreate(let userId): return (.post, "users/\(String(userId))/albums")
		case .albumUpdate(let userId, let albumId): return (.patch, "users/\(String(userId))/albums/\(String(albumId))")
		case .albumDelete(let userId, let albumId): return (.delete, "users/\(String(userId))/albums/\(String(albumId))")
		case .addImageToAlbum(let userId, let albumId, let imageId): return (.post, "users/\(String(userId))/albums/\(String(albumId))/images/\(String(imageId))")
		case .deleteImageToAlbum(let userId, let albumId, let imageId): return (.delete, "users/\(String(userId))/albums/\(String(albumId))/images/\(String(imageId))")
		}
	}
}

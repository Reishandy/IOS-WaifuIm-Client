//
//  OrderByFilterType.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

enum OrderByFilterType: String, CaseIterable, Identifiable {
	case random = "Random"
	case uploadedAt = "UploadedAt"
	case favorites = "Favorites"
	case addedToAlbum = "AddedToAlbum"
	
	var id: Self { self }
	var description: String {
		switch self {
		case .random:
			return "Random"
		case .uploadedAt:
			return "Newest First"
		case .favorites:
			return "Most Popular"
		case .addedToAlbum:
			return "Added to Album"
		}
	}
}

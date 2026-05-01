//
//  BooleanFilterType.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

enum BooleanFilterType: String, CaseIterable, Identifiable {
	case isFalse = "False"
	case isTrue = "True"
	case all = "All"
	
	var id: Self { self }
	var descriptionNsfw: String {
		switch self {
		case .isFalse:
			"Safe"
		case .isTrue:
			"NSFW (18+)"
		case .all:
			"All Content"
		}
	}
	var descriptionAnimated: String {
		switch self {
		case .isFalse:
			"Static Image"
		case .isTrue:
			"Animated (GIF)"
		case .all:
			"All Content"
		}
	}
}

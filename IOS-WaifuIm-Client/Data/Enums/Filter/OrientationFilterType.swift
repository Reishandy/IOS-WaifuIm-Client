//
//  OrientationFilterType.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

enum OrientationFilterType: String, CaseIterable, Identifiable {
	case all = "All"
	case landscape = "Landscape"
	case potrait = "Potrait"
	case square = "Square"
	
	var id: Self { self }
	var description: String {
		switch self {
		case .all:
			return "Any"
		case .landscape:
			return "Landscape"
		case .potrait:
			return "Potrait"
		case .square:
			return "Square"
		}
	}
}

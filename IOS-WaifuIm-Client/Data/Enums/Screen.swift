//
//  Screen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 03/05/26.
//

enum Screen: Hashable {
	case imageDetailScreen(imageId: Int)
	case tagScreen
	case artistScreen
	case albumScreen
	case albumImageScreen(albumId: Int)
}

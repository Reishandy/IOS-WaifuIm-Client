//
//  AlbumFormContext.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 03/05/26.
//

import Foundation

struct AlbumFormContext: Identifiable {
	let id = UUID()
	var editId: Int?
	var name: String
	var description: String
}

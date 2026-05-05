//
//  ShareItems.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 05/05/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct PngShareItem: Transferable {
	let data: Data
	static var transferRepresentation: some TransferRepresentation {
		DataRepresentation(exportedContentType: .png) { $0.data }
	}
}

struct JpegShareItem: Transferable {
	let data: Data
	static var transferRepresentation: some TransferRepresentation {
		DataRepresentation(exportedContentType: .jpeg) { $0.data }
	}
}

struct GifShareItem: Transferable {
	let data: Data
	static var transferRepresentation: some TransferRepresentation {
		DataRepresentation(exportedContentType: .gif) { $0.data }
	}
}

struct WebPShareItem: Transferable {
	let data: Data
	static var transferRepresentation: some TransferRepresentation {
		DataRepresentation(exportedContentType: .webP) { $0.data }
	}
}

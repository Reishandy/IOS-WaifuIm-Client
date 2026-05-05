//
//  DataExtension.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 05/05/26.
//

import Foundation
import UniformTypeIdentifiers

extension Data {
	var imageUTType: UTType {
		// We need at least 12 bytes to safely check all formats (WebP requires checking bytes 8-11)
		guard self.count >= 12 else { return .image }
		
		let bytes = [UInt8](self.prefix(12))
		
		// GIF: Starts with "GIF"
		if bytes.starts(with: [0x47, 0x49, 0x46]) { return .gif }
		
		// PNG: Starts with 89 50 4E 47
		if bytes.starts(with: [0x89, 0x50, 0x4E, 0x47]) { return .png }
		
		// JPEG: Starts with FF D8 FF
		if bytes.starts(with: [0xFF, 0xD8, 0xFF]) { return .jpeg }
		
		// WebP: Starts with "RIFF" (0-3) and contains "WEBP" at bytes 8-11
		if bytes[0...3] == [0x52, 0x49, 0x46, 0x46] && bytes[8...11] == [0x57, 0x45, 0x42, 0x50] {
			return .webP
		}
		
		return .image
	}
}

//
//  APIService.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import Foundation

actor APIService {
	private let apiUrl: String = "https://api.waifu.im/"
	
	func fetchImages(filter: FilterState) async throws -> ResponseImageFetch {
		// TODO: Build the filter
		
		guard let url = buildUrl(path: .images, filter: filter) else {
			throw APIError.invalidURL
		}
		
		do {
			let (data, response) = try await URLSession.shared.data(from: url)
			
			guard let httpResponse = response as? HTTPURLResponse else {
				throw APIError.serverError
			}
			
			if (200...299).contains(httpResponse.statusCode) {
				return try JSONDecoder().decode(ResponseImageFetch.self, from: data)
			}
			
			if httpResponse.statusCode == 401 {
				throw APIError.unauthorized
			}
			
			if let errorResponse = try? JSONDecoder().decode(ResponseError.self, from: data) {
				throw APIError.badRequest(errorResponse)
			} else {
				throw APIError.serverError
			}
		} catch let error as URLError where error.code == .notConnectedToInternet {
			throw APIError.noNetwork
		} catch let error as APIError {
			throw error
		} catch {
			print("> Parsing error: \(error)")
			throw APIError.decodingError
		}
	}
	
	private func buildUrl(path: APIPath, filter: FilterState? = nil) -> URL? {
		var urlString = self.apiUrl + path.rawValue
		
		if let filter {
			urlString += "?IsNsfw=\(filter.isNsfw.rawValue)&"
			
			for includedTag in filter.includedTags {
				urlString += "IncludedTags=\(includedTag)&"
			}
			
			for excludedTag in filter.excludedTags {
				urlString += "ExcludedTags=\(excludedTag)&"
			}
			
			for IncludedArtist in filter.IncludedArtists {
				urlString += "IncludedArtists=\(IncludedArtist)&"
			}
			
			for excludedArtiest in filter.excludedArtiests {
				urlString += "ExcludedArtists=\(excludedArtiest)&"
			}
			
			for IncludedId in filter.IncludedIds {
				urlString += "IncludedIds=\(IncludedId)&"
			}
			
			for excludedId in filter.excludedIds {
				urlString += "ExcludedIds\(excludedId)&"
			}
			
			urlString += "IsAnimated=\(filter.isAnimated.rawValue)&"
			
			urlString += "OrderBy=\(filter.orderBy.rawValue)&"
			
			urlString += "Orientation=\(filter.orientation.rawValue)&"
			
			urlString += "Page=\(filter.page)&"
			
			urlString += "PageSize=\(filter.pageSize)&"
			
			if let width = filter.width {
				urlString += "Width=\(width.stringValue)&"
			}
			
			if let height = filter.height {
				urlString += "Height=\(height.stringValue)&"
			}
			
			if let byteSize = filter.byteSize {
				urlString += "ByteSize=\(byteSize)&"
			}
		}
		
		return URL(string: urlString)
	}
}

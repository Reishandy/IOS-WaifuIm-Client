//
//  APIService.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import Foundation

actor APIService {
	static let shared: APIService = APIService()
	
	private let apiUrl: String = "https://api.waifu.im/"
	
	func fetchData<T: APIResource>(filter: FilterState? = nil) async throws -> ResponseFetch<T> {
		guard let url = buildUrl(path: T.path, filter: filter) else {
			throw APIError.invalidURL
		}
		
		do {
			var request = URLRequest(url: url)
			
			request.setValue("v7", forHTTPHeaderField: "Accept-Version")
			
			let (data, response) = try await URLSession.shared.data(for: request)
			
			guard let httpResponse = response as? HTTPURLResponse else {
				throw APIError.serverError
			}
			
			if (200...299).contains(httpResponse.statusCode) {
				return try JSONDecoder().decode(ResponseFetch<T>.self, from: data)
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
			
			for includedArtists in filter.includedArtists {
				urlString += "IncludedArtists=\(includedArtists)&"
			}
			
			for excludedArtists in filter.excludedArtists {
				urlString += "ExcludedArtists=\(excludedArtists)&"
			}
			
			for includedIds in filter.includedIds {
				urlString += "IncludedIds=\(includedIds)&"
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
		
		// Not a good thing to do really
		switch path {
		case .images:
			return URL(string: urlString)
		case .tags:
			urlString += "?PageSize=9999"
			return URL(string: urlString)
		case .artists:
			urlString += "?PageSize=9999"
			return URL(string: urlString)
		}
	}
}

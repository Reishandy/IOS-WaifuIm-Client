//
//  APIService.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import Foundation

actor APIService {
	private let apiUrl: String = "https://api.waifu.im"
	
	func fetchImages() async throws -> ResponseImageFetch {
		// TODO: Build the filter
		
		guard let url = URL(string: "\(self.apiUrl)/images") else {
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
}

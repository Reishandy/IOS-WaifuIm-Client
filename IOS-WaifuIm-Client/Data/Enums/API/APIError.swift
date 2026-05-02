//
//  APIError.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import Foundation

enum APIError: LocalizedError, Equatable {
	case invalidURL
	case badRequest(ResponseError)
	case unauthorized
	case serverError
	case decodingError
	case noNetwork
	
	var errorDescription: String? {
		switch self {
		case .invalidURL:
			return "The endpoint URL is invalid."
		case .badRequest(let responseError):
			return "\(responseError.title ?? "Error"): \(responseError.detail ?? "Soething went wrong")"
		case .unauthorized:
			return "Your session has expired. Please log in again."
		case .serverError:
			return "The server is currently experiencing issues. Please try again later."
		case .decodingError:
			return "There was a problem reading the data from the server."
		case .noNetwork:
			return "It looks like you're offline. Check your connection."
		}
	}
}

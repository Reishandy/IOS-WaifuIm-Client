//
//  AppManager.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI
import KeychainAccess

@MainActor
@Observable
class AppManager {
	var fetchedImageResponses: [ResponseImage] = []
	var fetchedTagResponses: [ResponseTag] = []
	var fetchedArtistResponses: [ResponseArtist] = []
	var profile: ResponseProfile? = nil
	
	var isFetchingImages: Bool = false
	var filterState: FilterState = FilterState.defultFilter
	var error: APIError? = nil
	var showError: Bool = false
	var hasMoreImage: Bool = false
	
	private let keychain: Keychain = Keychain(service: "id.reishandy.waifuimios")
	
	init() {
		Task {
			let apiKey = keychain["api_key"]
			
			if let apiKey = apiKey {
				await doApiRequest {
					self.profile = try await APIService.shared.fetchData(apiKey: apiKey)
				}
			}
			
			await self.fetchImages()
			
			await self.doApiRequest {
				let artistResponse: ResponseFetch<ResponseArtist> = try await APIService.shared.fetchData(apiKey: apiKey)
				fetchedArtistResponses = artistResponse.items
				
				let tagResponse: ResponseFetch<ResponseTag> = try await APIService.shared.fetchData(apiKey: apiKey)
				fetchedTagResponses = tagResponse.items
			}
		}
	}
	
	func fetchImages() async {
		guard !isFetchingImages else { return }
		
		self.isFetchingImages = true
		
		await self.doApiRequest {
			let response: ResponseFetch<ResponseImage> = try await APIService.shared.fetchData(apiKey: self.keychain["api_key"], filter: self.filterState)
			
			self.hasMoreImage = response.hasNextPage
			
			for item in response.items {
				fetchedImageResponses.append(item)
			}
		}
		
		self.isFetchingImages = false
	}
	
	func storeAPIKey(apiKey: String) async {
		guard apiKey.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return }
		
		self.keychain["api_key"] = apiKey
		
		await doApiRequest {
			self.profile = try await APIService.shared.fetchData(apiKey: apiKey)
		}
	}
	
	func removeAPIKey() {
		self.keychain["api_key"] = nil
		self.profile = nil
	}
	
	private func doApiRequest(action: () async throws -> Void) async {
		do {
			try await action()
		} catch let apiError as APIError {
			// TODO: Check 401 then reset account
			
			self.error = apiError
			self.showError = true
		} catch {
			self.error = .serverError
			self.showError = true
		}
	}
}

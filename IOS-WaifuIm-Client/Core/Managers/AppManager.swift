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
	var fetchedAlbumResponses: [ResponseAlbum]? = nil
	var profile: ResponseProfile? = nil
	
	var isFetchingImages: Bool = false
	var filterState: FilterState = FilterState.defultFilter
	var error: APIError? = nil
	var showError: Bool = false
	var hasMoreImage: Bool = false
	
	private let keychain: Keychain = Keychain(service: "id.reishandy.waifuimios")
	private let apiKeyAccessor: String = "api_key"
	private let apiService: APIService = APIService()
	
	init(apiKeyOveride: String? = nil) {
		if let apiKeyOveride = apiKeyOveride {
			keychain[self.apiKeyAccessor] = apiKeyOveride
		}
		
		Task {
			let apiKey = keychain[self.apiKeyAccessor]
			
			if let apiKey = apiKey {
				await doApiRequest {
					self.profile = try await self.apiService.callAPI(.profile, apiKey: apiKey)
				}
			}
			
			await self.fetchImages()
			
			await self.doApiRequest {
				let artistResponse: ResponseFetch<ResponseArtist> = try await self.apiService.callAPI(.artists, apiKey: apiKey)
				fetchedArtistResponses = artistResponse.items
				
				let tagResponse: ResponseFetch<ResponseTag> = try await self.apiService.callAPI(.tags, apiKey: apiKey)
				fetchedTagResponses = tagResponse.items
			}
			
			await self.fetchAlbums()
		}
	}
	
	func fetchImages() async {
		guard !isFetchingImages else { return }
		
		self.isFetchingImages = true
		
		await self.doApiRequest {
			let response: ResponseFetch<ResponseImage> = try await self.apiService.callAPI(.images, apiKey: self.keychain[self.apiKeyAccessor], filter: self.filterState)
			
			self.hasMoreImage = response.hasNextPage
			
			for item in response.items {
				fetchedImageResponses.append(item)
			}
		}
		
		self.isFetchingImages = false
	}
	
	func fetchAlbums() async {
		guard let id = self.profile?.id else { return }
		
		await self.doApiRequest {
			let albumResponse: ResponseFetch<ResponseAlbum> = try await self.apiService.callAPI(.albums(userId: id), apiKey: self.keychain[self.apiKeyAccessor])
			
			self.fetchedAlbumResponses = albumResponse.items
		}
	}
	
	func storeAPIKey(apiKey: String) async {
		guard apiKey.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return }
		
		self.keychain["api_key"] = apiKey
		
		await doApiRequest {
			self.profile = try await self.apiService.callAPI(.profile, apiKey: apiKey)
		}
		
		await self.fetchAlbums()
	}
	
	func removeAPIKey() {
		self.keychain["api_key"] = nil
		self.profile = nil
		self.fetchedAlbumResponses = nil
	}
	
	private func doApiRequest(action: () async throws -> Void) async {
		do {
			try await action()
		} catch let apiError as APIError {
			if apiError == .unauthorized {
				self.removeAPIKey()
			}
			
			self.error = apiError
			self.showError = true
		} catch {
			self.error = .serverError
			self.showError = true
		}
	}
}

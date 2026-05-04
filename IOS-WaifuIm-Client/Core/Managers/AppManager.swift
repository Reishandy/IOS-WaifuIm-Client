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
	var imageResponses: [ResponseImage] = []
	var tagResponses: [ResponseTag] = []
	var artistResponses: [ResponseArtist] = []
	var albumResponses: [ResponseAlbum]? = nil
	var profile: ResponseProfile? = nil
	
	var isFetchingImages: Bool = true
	var isFetchingImagasAlbum: Bool = false
	var filterState: FilterState = FilterState.defultFilter
	var error: APIError? = nil
	var showError: Bool = false
	var hasMoreImage: Bool = false
	
	private let keychain: Keychain = Keychain(service: "id.reishandy.waifuimios")
	private let apiKeyAccessor: String = "api_key"
	private let apiService: APIService = APIService()
	
	init() {
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
				artistResponses = artistResponse.items
				
				let tagResponse: ResponseFetch<ResponseTag> = try await self.apiService.callAPI(.tags, apiKey: apiKey)
				tagResponses = tagResponse.items
			}
			
			await self.fetchAlbums()
		}
	}
	
	func fetchImages() async {
		self.isFetchingImages = true
		
		await self.doApiRequest {
			let response: ResponseFetch<ResponseImage> = try await self.apiService.callAPI(.images, apiKey: self.keychain[self.apiKeyAccessor], filter: self.filterState)
			
			self.hasMoreImage = response.hasNextPage
			
			for item in response.items {
				imageResponses.append(item)
			}
		}
		
		self.isFetchingImages = false
	}
	
	func fetchImage(imageId: Int) async -> ResponseImage? {
		var imageResponse: ResponseImage? = nil
		
		await self.doApiRequest {
			imageResponse = try await self.apiService.callAPI(.image(imageId: imageId), apiKey: self.keychain[self.apiKeyAccessor])
		}
		
		return imageResponse
	}
	
	func fetchAlbumImages(albumId: Int, currentPage: Int) async -> (hasNextPage: Bool, imageResponses: [ResponseImage]) {
		guard let userId = self.profile?.id else { return (false, []) }
		
		self.isFetchingImagasAlbum = true
		
		var albumImages: [ResponseImage] = []
		var hasNextPage: Bool = false
		
		await self.doApiRequest {
			let response: ResponseFetch<ResponseImage> = try await self.apiService.callAPI(
				.albumImages(userId: userId, albumId: albumId),
				apiKey: self.keychain[self.apiKeyAccessor],
				filter: FilterState(
					isNsfw: .all,
					includedTags: [],
					excludedTags: [],
					includedArtists: [],
					excludedArtists:[],
					includedIds: [],
					excludedIds: [],
					isAnimated: .all,
					orderBy: .addedToAlbum,
					orientation: .all,
					page: currentPage,
					pageSize: 30
				)
			)
			
			albumImages = response.items
			hasNextPage = response.hasNextPage
		}
		
		self.isFetchingImagasAlbum = false
		
		return (hasNextPage, albumImages)
	}
	
	func fetchAlbums() async {
		guard let userId = self.profile?.id else { return }
		
		await self.doApiRequest {
			let albumResponse: ResponseFetch<ResponseAlbum> = try await self.apiService.callAPI(
				.albums(userId: userId),
				apiKey: self.keychain[self.apiKeyAccessor]
			)
			
			self.albumResponses = albumResponse.items
		}
	}
	
	func createAlbum(name: String, description: String) async {
		guard let userId = self.profile?.id else { return }
		
		let body = BodyAlbum(
			name: name, description: description
		)
		
		await self.doApiRequest {
			let _: ResponseAlbum = try await self.apiService.callAPI(
				.albumCreate(userId: userId),
				body: body,
				apiKey: self.keychain[self.apiKeyAccessor]
			)
		}
		
		await self.fetchAlbums()
	}
	
	func updateAlbum(albumId: Int, name: String, description: String) async {
		guard let userId = self.profile?.id else { return }
		
		let body = BodyAlbum(
			name: name, description: description
		)
		
		await self.doApiRequest {
			let _: ResponseAlbum = try await self.apiService.callAPI(
				.albumUpdate(userId: userId, albumId: albumId),
				body: body,
				apiKey: self.keychain[self.apiKeyAccessor]
			)
		}
		
		await self.fetchAlbums()
	}
	
	func deleteAlbum(albumId: Int) async {
		guard let userId = self.profile?.id else { return }
		
		await self.doApiRequest {
			let _: ResponseEmpty = try await self.apiService.callAPI(
				.albumDelete(userId: userId, albumId: albumId),
				apiKey: self.keychain[self.apiKeyAccessor]
			)
			
			self.albumResponses?.removeAll { $0.id == albumId }
		}
	}
	
	func imageToAlbum(albumId: Int, imageId: Int, isDelete: Bool = false) async {
		guard let userId = self.profile?.id else { return }
		
		await self.doApiRequest {
			let _: ResponseEmpty = try await self.apiService.callAPI(
				isDelete ? .deleteImageToAlbum(userId: userId, albumId: albumId, imageId: imageId) : .addImageToAlbum(userId: userId, albumId: albumId, imageId: imageId),
				apiKey: self.keychain[self.apiKeyAccessor]
			)
		}
	}
	
	func fetchOnlyTagOrArtist(slug: String? = nil, artistId: Int? = nil) async {
		self.filterState = FilterState.defultFilter
		self.filterState.orderBy = .uploadedAt
		
		if let slug = slug {
			self.filterState.includedTags = [slug]
		}
		
		if let artistId = artistId {
			self.filterState.includedArtists = [String(artistId)]
		}
		
		self.imageResponses = []
		await self.fetchImages()
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
		self.albumResponses = nil
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

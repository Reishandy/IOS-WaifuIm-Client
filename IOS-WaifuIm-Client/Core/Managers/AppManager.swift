//
//  AppManager.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

@MainActor
@Observable
class AppManager {
	var fetchedImageResponses: [ResponseImage] = []
	var fetchedTagResponses: [ResponseTag] = []
	var fetchedArtistResponses: [ResponseArtist] = []
	
	var isFetchingImages: Bool = false
	var filterState: FilterState = FilterState.defultFilter
	var error: APIError? = nil
	var showError: Bool = false
	var hasMoreImage: Bool = false
	
	private var jwtToken: String? = nil
	
	init() {
		Task {
			await self.fetchImages()
			
			await self.doApiRequest {
				let artistResponse: ResponseFetch<ResponseArtist> = try await APIService.shared.fetchData()
				fetchedArtistResponses = artistResponse.items
				
				let tagResponse: ResponseFetch<ResponseTag> = try await APIService.shared.fetchData()
				fetchedTagResponses = tagResponse.items
			}
		}
	}
	
	func fetchImages() async {
		guard !isFetchingImages else { return }
		
		self.isFetchingImages = true
		
		await self.doApiRequest {
			let response: ResponseFetch<ResponseImage> = try await APIService.shared.fetchData(filter: self.filterState)
			
			self.hasMoreImage = response.hasNextPage
			
			for item in response.items {
				fetchedImageResponses.append(item)
			}
		}
		
		self.isFetchingImages = false
	}
	
	func login() async {
		await self.doApiRequest {
			let discordOauth2Code = try await AuthManager.shared.getDiscordOAuthCode()
			
			print(discordOauth2Code)
			
			let response: ResponseJWT = try await APIService.shared.postData(body: BodyJWT(code: discordOauth2Code))
			
			self.jwtToken = response.string
			
			// TODO: BROKEN... 400
			
			print(response)
			
			// TODO: Store to shared preference
		}
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

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
	var isFetchingTags: Bool = false
	var isFetchingArtists: Bool = false
	
	var filterState: FilterState = FilterState.defultFilter
	var error: APIError? = nil
	var showError: Bool = false
	var hasMoreImage: Bool = false
	
	init() {
		Task {
			await self.fetchImages()
			await self.fetchTags()
			await self.fetchArtists()
		}
	}
	
	func fetchImages() async {
		guard !isFetchingImages else { return }
		
		self.isFetchingImages = true
		
		do {
			let response: ResponseFetch<ResponseImage> = try await APIService.shared.fetchData(filter: self.filterState)
			
			self.hasMoreImage = response.hasNextPage
			
			for item in response.items {
				fetchedImageResponses.append(item)
			}
		} catch let apiError as APIError {
			self.error = apiError
			self.showError = true
		} catch {
			self.error = .serverError
			self.showError = true
		}
		
		self.isFetchingImages = false
	}
	
	func fetchTags() async {
		guard !isFetchingTags else { return }
		
		self.isFetchingTags = true
		
		do {
			let response: ResponseFetch<ResponseTag> = try await APIService.shared.fetchData()
			
			fetchedTagResponses = response.items
		} catch let apiError as APIError {
			self.error = apiError
			self.showError = true
		} catch {
			self.error = .serverError
			self.showError = true
		}
		
		self.isFetchingTags = false
	}
	
	func fetchArtists() async {
		guard !isFetchingArtists else { return }
		
		self.isFetchingArtists = true
		
		do {
			let response: ResponseFetch<ResponseArtist> = try await APIService.shared.fetchData()
			
			fetchedArtistResponses = response.items
		} catch let apiError as APIError {
			self.error = apiError
			self.showError = true
		} catch {
			self.error = .serverError
			self.showError = true
		}
		
		self.isFetchingArtists = false
	}
}

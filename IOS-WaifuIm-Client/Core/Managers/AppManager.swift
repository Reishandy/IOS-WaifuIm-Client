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
	var fetchedImage: [String: UIImage] = [:]
	var isLoading: Bool =  false
	var filterState: FilterState = FilterState(
		isNsfw: BooleanFilterType.isFalse,
		includedTags: [],
		excludedTags: [],
		IncludedArtists: [],
		excludedArtiests: [],
		IncludedIds: [],
		excludedIds: [],
		isAnimated: .all,
		orderBy: .random,
		orientation: .all,
		page: 1,
		pageSize: 10,
		width: nil,
		height: nil,
		byteSize: nil
	)
	var error: APIError? = nil
	var showError: Bool = false
	
	func fetchImages() async {
		guard !isLoading else { return }
		
		self.isLoading = true
		
		do {
			let response = try await APIService.shared.fetchImages(filter: self.filterState)
			
			for item in response.items {
				// TODO: Possibly trigger the UIImage fetch here?
				fetchedImageResponses.append(item)
			}
		} catch let apiError as APIError {
			self.error = apiError
			self.showError = true
		} catch {
			self.error = .serverError
			self.showError = true
		}
		
		self.isLoading = false
	}
}

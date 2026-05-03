//
//  FilterView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 01/05/26.
//

import SwiftUI

struct FilterView: View {
	@Environment(AppManager.self) private var appManager
	
	@Binding var filterState: FilterState
	
	var body: some View {
		
		VStack(alignment: .leading, spacing: 20) {
			VStack(alignment: .leading, spacing: 12) {
				Text("Order By")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				Picker("Order By", selection: $filterState.orderBy) {
					ForEach(OrderByFilterType.allCases) { option in
						if option != .addedToAlbum {
							Text(option.description).tag(option)
						}
					}
				}
				.pickerStyle(.segmented)
			}
			
			VStack(alignment: .leading, spacing: 12) {
				Text("Content Rating")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				Picker("NSFW", selection: $filterState.isNsfw) {
					ForEach(BooleanFilterType.allCases) { option in
						Text(option.descriptionNsfw).tag(option)
					}
				}
				.pickerStyle(.segmented)
			}
			
			Divider()
			
			VStack(alignment: .leading, spacing: 12) {
				Text("Orientation")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				Picker("Orientation", selection: $filterState.orientation) {
					ForEach(OrientationFilterType.allCases) { option in
						Text(option.description).tag(option)
					}
				}
				.pickerStyle(.segmented)
			}
			
			VStack(alignment: .leading, spacing: 12) {
				Text("Type")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				Picker("Animated", selection: $filterState.isAnimated) {
					ForEach(BooleanFilterType.allCases) { option in
						Text(option.descriptionAnimated).tag(option)
					}
				}
				.pickerStyle(.segmented)
			}
			
			SizeFilterView(title: "Width", sizeFilter: $filterState.width)
			
			SizeFilterView(title: "Height", sizeFilter: $filterState.height)
			
			SizeFilterView(title: "Byte Size", sizeFilter: $filterState.byteSize)
			
			Divider()
			
			VStack(alignment: .leading, spacing: 12) {
				Text("Included Tags")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				TokenFieldView(
					fieldText: "Search tags...",
					itemOptions: appManager.tagResponses,
					tokens: $filterState.includedTags,
				)
			}
			
			VStack(alignment: .leading, spacing: 12) {
				Text("Excluded Tags")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				TokenFieldView(
					fieldText: "Exclude tags...",
					itemOptions: appManager.tagResponses,
					tokens: $filterState.excludedTags,
				)
			}
			
			Divider()
			
			VStack(alignment: .leading, spacing: 12) {
				Text("Included Artists")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				TokenFieldView(
					fieldText: "Search artists...",
					itemOptions: appManager.artistResponses,
					tokens: $filterState.includedArtists,
				)
			}
			
			VStack(alignment: .leading, spacing: 12) {
				Text("Excluded Artists")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				TokenFieldView(
					fieldText: "Exclude artists...",
					itemOptions: appManager.artistResponses,
					tokens: $filterState.excludedArtists,
				)
			}
			
			Divider()
			
			VStack(alignment: .leading, spacing: 12) {
				Text("Included IDs")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				TokenFieldView(
					fieldText: "Press enter to add ID...",
					isNumeric: true,
					tokens: $filterState.includedIds
				)
			}
			
			VStack(alignment: .leading, spacing: 12) {
				Text("Excluded IDs")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				TokenFieldView(
					fieldText: "Press enter to add ID...",
					isNumeric: true,
					tokens: $filterState.excludedIds
				)
			}
		}
		.padding(.top, 48)
		.padding(.horizontal, 14)
	}
}

#Preview {
	@Previewable @State var filter = FilterState.defultFilter
	
	ScrollView {
		FilterView(filterState: $filter	)
			.environment(AppManager())
	}
}

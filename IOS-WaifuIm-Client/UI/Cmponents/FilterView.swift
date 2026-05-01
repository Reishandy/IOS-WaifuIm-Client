//
//  FilterView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 01/05/26.
//

import SwiftUI

struct FilterView: View {
	@Binding var filterState: FilterState
	
	var body: some View {
		ScrollView {
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
				
				// TODO: Include Exclude stuff
				
				Spacer()
			}
		}
		.padding(.top, 48)
		.padding(.horizontal, 14)
	}
}

#Preview {
	FilterView(filterState: .constant(FilterState.defultFilter))
}

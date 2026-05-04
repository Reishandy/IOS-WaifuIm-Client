//
//  ImageListView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 01/05/26.
//

import SwiftUI

struct ImageListView: View {
	@Environment(AppManager.self) private var appManager
	
	let imageResponses: [ResponseImage]
	let isLoading: Bool
	let isRandomOrder: Bool
	let hasMoreImage: Bool
	let populate: (Bool) -> Void
	let isSingleColumn: Bool
	
	@Binding var scrollPosition: ScrollPosition
	
	@State private var cachedColumnsData: [[ResponseImage]] = []
	
	private var bottomText: String {
		if isRandomOrder {
			"Refresh to get new random images"
		} else if !hasMoreImage {
			"That is it, no more images"
		} else {
			"Pull to load more images"
		}
	}
	
	private func generateColumnsData(for imageList: [ResponseImage], columnCount: Int) -> [[ResponseImage]] {
		var columns: [[ResponseImage]] = Array(repeating: [], count: columnCount)
		var columnHeights: [CGFloat] = Array(repeating: 0, count: columnCount)
		
		for image in imageList {
			let shortestColumnIndex = columnHeights.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
			columns[shortestColumnIndex].append(image)
			
			columnHeights[shortestColumnIndex] += CGFloat(image.height) / CGFloat(image.width)
		}
		
		return columns
	}
	
	var body: some View {
		GeometryReader { geometry in
			let screenWidth = geometry.size.width
			let dynamicColumnCount = getDynamicColumnCount(screenWidth: screenWidth)
			
			ScrollView {
				HStack(alignment: .top) {
					ForEach(0..<cachedColumnsData.count, id: \.self) { columnIndex in
						let imagesInColumn = cachedColumnsData[columnIndex]
						
						LazyVStack {
							ForEach(imagesInColumn) { item in
								let columnWidth = screenWidth / CGFloat(cachedColumnsData.count)
								let displayHeight = (columnWidth / CGFloat(item.width)) * CGFloat(item.height)
								
								NavigationLink(value: Screen.imageDetailScreen(imageId: item.id)) {
									ImageItemView(imageUrl: item.url, width: columnWidth, height: displayHeight)
										.clipShape(RoundedRectangle(cornerRadius: 10))
										.padding(.bottom, -6)
										.padding(.horizontal, 2)
								}
							}
						}
					}
				}
				
				if isLoading {
					ProgressView().padding(.top, 12)
				} else {
					Text(bottomText).opacity(0.4).font(.subheadline).padding(.top, 6)
				}
			}
			.scrollPosition($scrollPosition)
			.onScrollGeometryChange(for: Bool.self) { geometry in
				let contentHeight = geometry.contentSize.height
				let containerHeight = geometry.containerSize.height
				let currentOffset = geometry.contentOffset.y
				
				return currentOffset + containerHeight >= (contentHeight - 50)
			} action: { oldValue, newValue in
				Task { @MainActor in
					if newValue && !oldValue && !isRandomOrder {
						populate(false)
					}
				}
			}
			.task(id: imageResponses.hashValue) {
				Task { @MainActor in
					self.cachedColumnsData = generateColumnsData(for: imageResponses, columnCount: getDynamicColumnCount(screenWidth: screenWidth))
				}
			}
			.onChange(of: dynamicColumnCount) {
				Task { @MainActor in
					withAnimation {
						self.cachedColumnsData = generateColumnsData(for: imageResponses, columnCount: dynamicColumnCount)
					}
				}
			}
			.refreshable { populate(true) }
		}
	}
	
	private func getDynamicColumnCount(screenWidth: CGFloat) -> Int {
		if isSingleColumn || imageResponses.count <= 1 { return 1 }
		
		if screenWidth > 1000 {
			return 4
		} else if screenWidth > 500 {
			return 3
		} else {
			return 2
		}
	}
}

#Preview {
	ImageListView(
		imageResponses: [],
		isLoading: false,
		isRandomOrder: false,
		hasMoreImage: false,
		populate: {_ in },
		isSingleColumn: false,
		scrollPosition: .constant(ScrollPosition())
	)
	.environment(AppManager())
}

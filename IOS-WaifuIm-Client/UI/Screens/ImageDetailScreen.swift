//
//  ImageDetailScreen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct ImageDetailScreen: View {
	@Namespace private var imageDetailScreenNameSpace
	
	var imageResponse: ResponseImage
	
	@State private var shouldHideToolbars: Bool = false
	@State private var isInfoSheetPresented: Bool = false
	@State private var currentInfoSheetDetent: PresentationDetent = .medium
	@State private var isAlbumSheetPresented: Bool = false
	@State private var currentAlbumSheetDetent: PresentationDetent = .medium
	@State private var currentZoom: CGFloat = 0.0
	@State private var totalZoom: CGFloat = 1.0
	@State private var currentOffset: CGSize = .zero
	@State private var totalOffset: CGSize = .zero
	@State private var loadedImage: UIImage? = nil
	
	var body: some View {
		GeometryReader { geometry in
			let size = geometry.size
			
			VStack {
				ImageItemView(imageUrl: imageResponse.url) { loadedImage in
					self.loadedImage = loadedImage
				}
				.scaleEffect(totalZoom + currentZoom)
				.offset(x: totalOffset.width + currentOffset.width,
						y: totalOffset.height + currentOffset.height)
				.onTapGesture {
					withAnimation {
						shouldHideToolbars.toggle()
					}
				}
				.onTapGesture(count: 2) {
					withAnimation(.spring()) {
						if totalZoom > 1.0 {
							totalZoom = 1.0
							totalOffset = .zero
							currentOffset = .zero
						} else {
							totalZoom = 3.0
						}
					}
				}
				.gesture(
					MagnifyGesture()
						.onChanged { value in
							currentZoom = value.magnification - 1
						}
						.onEnded { value in
							if totalZoom + currentZoom < 1.0 {
								withAnimation(.spring()) {
									totalZoom = 1.0
									currentOffset = .zero
									totalOffset = .zero
								}
							} else {
								totalZoom += currentZoom
							}
							currentZoom = 0
						}
				)
				.simultaneousGesture(
					DragGesture()
						.onChanged { value in
							if (totalZoom + currentZoom) > 1.0 {
								currentOffset = value.translation
							}
						}
						.onEnded { value in
							totalOffset.height += currentOffset.height
							totalOffset.width += currentOffset.width
							currentOffset = .zero
							
							let actualImageSize = loadedImage?.size ?? CGSize(width: size.width, height: size.height)
							let currentScale = totalZoom + currentZoom
							var renderedWidth = size.width
							var renderedHeight = size.height
							
							if actualImageSize.width > 0 && actualImageSize.height > 0 {
								let widthRatio = size.width / actualImageSize.width
								let heightRatio = size.height / actualImageSize.height
								let fitScale = min(widthRatio, heightRatio)
								
								renderedWidth = actualImageSize.width * fitScale
								renderedHeight = actualImageSize.height * fitScale
							}
							
							let scaledWidth = renderedWidth * currentScale
							let scaledHeight = renderedHeight * currentScale
							
							let maxX = max(0, (scaledWidth - size.width) / 2)
							let maxY = max(0, (scaledHeight - size.height) / 2)
							
							withAnimation(.spring()) {
								totalOffset.width = min(max(totalOffset.width, -maxX), maxX)
								totalOffset.height = min(max(totalOffset.height, -maxY), maxY)
							}
						}
				)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.ignoresSafeArea()
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Image #1234")
					.opacity(0.5)
					.padding(.horizontal, 16)
					.padding(.vertical, 12)
					.glassEffect(in: RoundedRectangle(cornerRadius: 20))
			}
			
			if let uiImage = loadedImage {
				ToolbarItem(placement: .topBarTrailing) {
					ShareLink(
						item: Image(uiImage: uiImage),
						preview: SharePreview("Share Image #\(imageResponse.id)", image: Image(uiImage: uiImage))
					)
				}
			}
			
			ToolbarItem(placement: .bottomBar) {
				Image(systemName: "folder.fill.badge.plus")
					.padding(.leading, 14)
					.onTapGesture {
						isAlbumSheetPresented = true
					}
					.matchedTransitionSource(id: "albumSheetSource", in: imageDetailScreenNameSpace)
			}
			
			ToolbarItem(placement: .bottomBar) {
				// TODO: Favorites
				Image(systemName: "heart")
					.padding(.trailing, 12)
			}
			
			ToolbarSpacer(placement: .bottomBar)
			
			ToolbarItem(placement: .bottomBar) {
				Image(systemName: "info")
					.onTapGesture {
						isInfoSheetPresented = true
					}
					.matchedTransitionSource(id: "infoSheetSource", in: imageDetailScreenNameSpace)
			}
		}
		.statusBarHidden(true)
		.toolbarVisibility(shouldHideToolbars ? .hidden : .visible, for: .navigationBar, .bottomBar)
		.sheet(isPresented: $isInfoSheetPresented) {
			// TODO: Replace placeholders
			InfoSheetView()
				.presentationDetents([.medium, .large], selection: $currentInfoSheetDetent)
				.navigationTransition(.zoom(sourceID: "infoSheetSource", in: imageDetailScreenNameSpace))
		}
		.sheet(isPresented: $isAlbumSheetPresented) {
			AlbumSheetView()
				.presentationDetents([.medium, .large], selection: $currentAlbumSheetDetent)
				.navigationTransition(.zoom(sourceID: "albumSheetSource", in: imageDetailScreenNameSpace))
		}
	}
}

#Preview {
	NavigationStack {
		ImageDetailScreen(imageResponse: ResponseImage(id: 1, perceptualHash: "", dominantColor: "", source: "", artists: [], uploaderId: 0, uploadedAt: "", isNsfw: false, isAnimated: false, width: 792, height: 729, byteSize: 48956, url: "https://github.com/Reishandy/Reishandy/blob/85b5bd0ef00735d277eaf41db3f28a5eb6e2c63a/repo/michiru_profile.webp?raw=true", tags: [], reviewStatus: "", favorites: 1, likedAt: .now, addedToAlbumAt: .now, albums: []))
	}
}

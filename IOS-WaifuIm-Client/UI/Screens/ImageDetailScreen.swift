//
//  ImageDetailScreen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct ImageDetailScreen: View {
	@Namespace private var imageDetailScreenNameSpace
	
	@Environment(AppManager.self) private var appManager
	@Environment(\.dismiss) var dismiss
	
	let imageId: Int
	let onTagTap: (String) -> Void
	let onArtistTap: (String) -> Void
	
	@State private var imageResponse: ResponseImage? = nil
	@State private var shouldHideToolbars: Bool = false
	@State private var isInfoSheetPresented: Bool = false
	@State private var isAlbumSheetPresented: Bool = false
	@State private var currentZoom: CGFloat = 0.0
	@State private var totalZoom: CGFloat = 1.0
	@State private var currentOffset: CGSize = .zero
	@State private var totalOffset: CGSize = .zero
	@State private var loadedImage: UIImage? = nil
	
	private var favoritesAlbumId: Int? {
		appManager.albumResponses?.first(where: { $0.isDefault == true})?.id
	}
	
	private var imageInAlbumsIds: Set<Int> {
		guard let imageResponse = imageResponse else { return [] }
		
		return Set(imageResponse.albums.map { $0.id })
	}
	
	var body: some View {
		@Bindable var appManager = appManager
		
		GeometryReader { geometry in
			let size = geometry.size
			
			if let imageResponse = imageResponse {
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
				.background(
					LinearGradient(
						stops: [
							.init(color: .clear, location: 0),
							.init(color: Color(uiColor: UIColor(hex: imageResponse.dominantColor)!), location: 0.5),
							.init(color: .clear, location: 1.0)
						],
						startPoint: .top,
						endPoint: .bottom
					)
					.ignoresSafeArea()
				)
			} else {
				ProgressView()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.ignoresSafeArea()
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Image #\(String(imageId))")
					.opacity(0.5)
					.padding(.horizontal, 16)
					.padding(.vertical, 12)
					.glassEffect(in: RoundedRectangle(cornerRadius: 20))
			}
			
			ToolbarItem(placement: .topBarTrailing) {
				if let uiImage = loadedImage {
					ShareLink(
						item: Image(uiImage: uiImage),
						preview: SharePreview("Share Image #\(String(imageResponse?.id ?? 0))", image: Image(uiImage: uiImage))
					)
				}
			}
			
			if let favoritesAlbumId = favoritesAlbumId, let imageResponse = imageResponse {
				ToolbarItem(placement: .bottomBar) {
					Button {
						isAlbumSheetPresented = true
					} label: {
						Image(systemName: "folder.badge.plus")
							.padding(.leading, 6)
							.padding(.trailing, -20)
					}
					.matchedTransitionSource(id: "albumSheetSource", in: imageDetailScreenNameSpace)
				}
				
				ToolbarItem(placement: .bottomBar) {
					let imageIsFavorited = imageInAlbumsIds.contains(favoritesAlbumId)
					
					Button {
						Task {
							await appManager.imageToAlbum(
								albumId: favoritesAlbumId,
								imageId: imageResponse.id,
								isDelete: imageIsFavorited
							)
							
							await populate()
						}
					} label: {
						Image(systemName: imageIsFavorited ? "heart.fill" : "heart")
							.foregroundStyle(imageIsFavorited ? .red : .primary)
							.padding(.trailing, 4)
					}
				}
			}
			
			ToolbarSpacer(placement: .bottomBar)
			
			ToolbarItem(placement: .bottomBar) {
				Button {
					isInfoSheetPresented = true
				} label: {
					Image(systemName: "info")
				}
				.matchedTransitionSource(id: "infoSheetSource", in: imageDetailScreenNameSpace)
			}
		}
		.statusBarHidden(true)
		.toolbarVisibility(shouldHideToolbars ? .hidden : .visible, for: .navigationBar, .bottomBar)
		.task {
			await populate()
		}
		.alert(
			"Oops!",
			isPresented: $appManager.showError,
			presenting: appManager.error
		) { _ in
			Button("OK", role: .cancel) { }
			Button("Retry") {
				Task {
					await populate()
				}
			}
		} message: { error in
			Text(error.localizedDescription)
		}
		.sheet(isPresented: $isInfoSheetPresented) {
			if let imageResponse = imageResponse {
				InfoSheetView(
					imageResponse: imageResponse,
					onTagTap: { slug in
						isInfoSheetPresented = false
						dismiss()
						
						onTagTap(slug)
					},
					onArtistTap: { id in
						isInfoSheetPresented = false
						dismiss()
						
						onArtistTap(id)
					},
					onFavoriteTap: {
						if let favoritesAlbumId = favoritesAlbumId {
							Task {
								await appManager.imageToAlbum(
									albumId: favoritesAlbumId,
									imageId: imageResponse.id,
									isDelete: imageInAlbumsIds.contains(favoritesAlbumId)
								)
								
								await populate()
							}
						}
					},
					isFavorited: imageInAlbumsIds.contains(favoritesAlbumId ?? -1)
				)
				.presentationDetents([.medium])
				.navigationTransition(.zoom(sourceID: "infoSheetSource", in: imageDetailScreenNameSpace))
			}
		}
		.sheet(isPresented: $isAlbumSheetPresented) {
			AlbumSheetView()
				.presentationDetents([.medium])
				.navigationTransition(.zoom(sourceID: "albumSheetSource", in: imageDetailScreenNameSpace))
		}
	}
	
	private func populate() async {
		self.imageResponse = await appManager.fetchImage(imageId: imageId)
	}
}

#Preview {
	NavigationStack {
		ImageDetailScreen(
			imageId: ResponseImage.mock.id,
			onTagTap: {	_ in },
			onArtistTap: { _ in }
		)
		.environment(AppManager())
	}
}

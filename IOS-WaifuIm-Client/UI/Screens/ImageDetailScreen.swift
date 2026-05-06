//
//  ImageDetailScreen.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImageDetailScreen: View {
	@Namespace private var imageDetailScreenNameSpace
	
	@Environment(AppManager.self) private var appManager
	@Environment(RouterManager.self) private var routerManager
	
	let imageId: Int
	
	@State private var imageResponse: ResponseImage? = nil
	@State private var shouldHideToolbars: Bool = false
	@State private var isInfoSheetPresented: Bool = false
	@State private var isAlbumSheetPresented: Bool = false
	@State private var scale: CGFloat = 1.0
	@State private var lastScale: CGFloat = 1.0
	@State private var offset: CGSize = .zero
	@State private var lastOffset: CGSize = .zero
	@State private var loadedImageData: Data? = nil
	
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
					ImageItemView(imageUrl: imageResponse.url, width: size.width, height: size.height){ loadedImageData in
						self.loadedImageData = loadedImageData
					}
					.scaleEffect(scale)
					.offset(offset)
					.onTapGesture(count: 2) {
						withAnimation(.spring()) {
							if scale > 1.0 {
								scale = 1.0
								offset = .zero
								lastScale = 1.0
								lastOffset = .zero
							} else {
								scale = 3.0
								lastScale = 3.0
							}
						}
					}
					.onTapGesture {
						withAnimation {
							shouldHideToolbars.toggle()
						}
					}
					.gesture(
						MagnifyGesture()
							.onChanged { value in
								scale = lastScale * value.magnification
								
								offset = CGSize(
									width: lastOffset.width * value.magnification,
									height: lastOffset.height * value.magnification
								)
							}
							.onEnded { value in
								if scale < 1.0 {
									withAnimation {
										scale = 1.0
										offset = .zero
									}
									lastScale = 1.0
									lastOffset = .zero
								} else {
									lastScale = scale
									enforceBoundaries(size: size)
								}
							}
					)
					.simultaneousGesture(
						DragGesture()
							.onChanged { value in
								if scale > 1.0 {
									offset = CGSize(
										width: lastOffset.width + value.translation.width,
										height: lastOffset.height + value.translation.height
									)
								}
							}
							.onEnded { value in
								lastOffset = offset
								enforceBoundaries(size: size)
							}
					)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(
					RadialGradient(
						stops: [
							.init(color: Color(uiColor: UIColor(hex: imageResponse.dominantColor)!), location: 0),
							.init(color: .clear, location: 1.0)
						],
						center: .center,
						startRadius: 0,
						endRadius: max(size.width, size.height)
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
				if let loadedImageData = loadedImageData, let uiImage = UIImage(data: loadedImageData) {
					let titleId = String(imageResponse?.id ?? 0)
					dynamicShareLink(data: loadedImageData, uiImage: uiImage, titleId: titleId)
				} else {
					ProgressView()
				}
			}
			
			if let favoritesAlbumId = favoritesAlbumId {
				ToolbarItem(placement: .bottomBar) {
					Button {
						isAlbumSheetPresented = true
					} label: {
						Image(systemName: "folder.badge.plus")
					}
					.padding(.leading, 6)
					.padding(.trailing, -20)
					.matchedTransitionSource(id: "albumSheetSource", in: imageDetailScreenNameSpace)
				}
				
				ToolbarItem(placement: .bottomBar) {
					let imageIsFavorited = imageInAlbumsIds.contains(favoritesAlbumId)
					
					Button {
						addToAlbum(albumId: favoritesAlbumId)
					} label: {
						Image(systemName: imageIsFavorited ? "heart.fill" : "heart")
							.foregroundStyle(imageIsFavorited ? .red : .primary)
							.padding(.trailing, 4)
							.contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.wholeSymbol), options: .nonRepeating))
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
						Task {
							isInfoSheetPresented = false
							
							try await Task.sleep(until: .now + .seconds(0.03), clock: .continuous)
							
							routerManager.reset()
							
							await appManager.fetchOnlyTagOrArtist(slug: slug)
						}
					},
					onArtistTap: { artistId in
						Task {
							isInfoSheetPresented = false
							
							try await Task.sleep(until: .now + .seconds(0.03), clock: .continuous)
							
							routerManager.reset()
							
							await appManager.fetchOnlyTagOrArtist(artistId: artistId)
						}
					},
					onFavoriteTap: {
						addToAlbum(albumId: favoritesAlbumId ?? -1)
					},
					isFavorited: imageInAlbumsIds.contains(favoritesAlbumId ?? -1)
				)
				.presentationDetents([.medium])
				.navigationTransition(.zoom(sourceID: "infoSheetSource", in: imageDetailScreenNameSpace))
			}
		}
		.sheet(isPresented: $isAlbumSheetPresented) {
			AlbumSheetView(
				imageInAlbumsIds: imageInAlbumsIds,
				onAlbumTap: { albumId in
					addToAlbum(albumId: albumId)
				}
			)
			.presentationDetents([.medium])
			.navigationTransition(.zoom(sourceID: "albumSheetSource", in: imageDetailScreenNameSpace))
		}
	}
	
	private func populate() async {
		self.imageResponse = await appManager.fetchImage(imageId: imageId)
	}
	
	private func addToAlbum(albumId: Int) {
		Task {
			let isDelete = imageInAlbumsIds.contains(albumId)
			
			if isDelete {
				imageResponse?.albums.removeAll(where: { $0.id == albumId })
			} else {
				imageResponse?.albums.append(contentsOf: appManager.albumResponses!.filter { $0.id == albumId })
			}
			
			await appManager.imageToAlbum(
				albumId: albumId,
				imageId: imageId,
				isDelete: isDelete
			)
			
			await populate()
		}
	}
	
	private func enforceBoundaries(size: CGSize) {
		guard let loadedImageData = loadedImageData,
			  let uiImage = UIImage(data: loadedImageData) else { return }
		
		let actualImageSize = uiImage.size
		var renderedWidth = size.width
		var renderedHeight = size.height
		
		if actualImageSize.width > 0 && actualImageSize.height > 0 {
			let widthRatio = size.width / actualImageSize.width
			let heightRatio = size.height / actualImageSize.height
			let fitScale = min(widthRatio, heightRatio)
			
			renderedWidth = actualImageSize.width * fitScale
			renderedHeight = actualImageSize.height * fitScale
		}
		
		let scaledWidth = renderedWidth * scale
		let scaledHeight = renderedHeight * scale
		
		let maxX = max(0, (scaledWidth - size.width) / 2)
		let maxY = max(0, (scaledHeight - size.height) / 2)
		
		withAnimation(.spring()) {
			offset.width = min(max(offset.width, -maxX), maxX)
			offset.height = min(max(offset.height, -maxY), maxY)
			lastOffset = offset
		}
	}
	
	@ViewBuilder
	private func dynamicShareLink(data: Data, uiImage: UIImage, titleId: String) -> some View {
		let preview = SharePreview("Share Image #\(titleId)", image: Image(uiImage: uiImage))
		let type = data.imageUTType
		
		if type == .gif {
			ShareLink(item: GifShareItem(data: data), preview: preview)
		} else if type == .png {
			ShareLink(item: PngShareItem(data: data), preview: preview)
		} else if type == .jpeg {
			ShareLink(item: JpegShareItem(data: data), preview: preview)
		} else if type == .webP {
			ShareLink(item: WebPShareItem(data: data), preview: preview)
		} else {
			ShareLink(item: Image(uiImage: uiImage), preview: preview)
		}
	}
}

#Preview {
	NavigationStack {
		ImageDetailScreen(imageId: ResponseImage.mock.id)
			.environment(AppManager())
			.environment(RouterManager())
	}
}

//
//  ContentView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct ContentView: View {
	@State private var router = RouterManager()
	
    var body: some View {
		NavigationStack(path: $router.path) {
			ImageListScreen()
				.navigationDestination(for: Screen.self) { screen in
					switch screen {
					case .imageDetailScreen(let imageId):
						ImageDetailScreen(imageId: imageId)
					case .tagScreen:
						TagScreen()
					case .artistScreen:
						ArtistScreen()
					case .albumScreen:
						AlbumScreen()
					case .albumImageScreen(let albumId):
						AlbumImageListScreen(albumId: albumId)
					}
				}
		}
		.environment(router)
    }
}

#Preview {
    ContentView()
		.environment(AppManager())
}

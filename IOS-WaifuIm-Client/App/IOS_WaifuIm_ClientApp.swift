//
//  IOS_WaifuIm_ClientApp.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

@main
struct IOS_WaifuIm_ClientApp: App {
	@State private var appManager: AppManager = AppManager()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(appManager)
        }
    }
}

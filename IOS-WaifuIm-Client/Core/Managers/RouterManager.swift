//
//  RouterManager.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 03/05/26.
//

import SwiftUI

@MainActor
@Observable
class RouterManager {
	var path = NavigationPath()
	
	func reset() {
		path = NavigationPath()
	}
}

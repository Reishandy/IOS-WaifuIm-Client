//
//  EmptyStateView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct EmptyStateView: View {
	var iconName: String
	var title: String
	var description: String
	var isSmall: Bool = false
	var actionButtonText: String?
	var action: (() -> Void)? = nil
	
	var body: some View {
		VStack(spacing: isSmall ? 8 : 24) {
			Image(systemName: iconName)
				.font(isSmall ? .title : .custom("iconExtraLarge", size: 70))
				.opacity(0.5)
			
			VStack(spacing: 10) {
				Text(title)
					.font(.title2)
					.bold()
				
				Text(description)
					.opacity(0.5)
					.multilineTextAlignment(.center)
			}
			
			if action != nil {
				Button(actionButtonText ?? "Action", action: action!)
					.buttonStyle(.glass)
			}
		}
		.padding()
	}
}

#Preview("Normal") {
	EmptyStateView(
		iconName: "tray", title: "No Item", description: "Add item first!"
	)
}

#Preview("Action") {
	EmptyStateView(
		iconName: "tray",
		title: "No Item",
		description: "Add item first!",
		actionButtonText: "Add Item"
	) {}
}

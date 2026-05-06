//
//  AccountView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

import SwiftUI

struct AccountView: View {
	let onSaveTap: (String) -> Void
	let onLogOutTap: () -> Void
	var profile: ResponseProfile? = nil
	
	@State private var inputText: String = ""
	@State private var isConfirmaionPresented: Bool = false
	
	var body: some View {
		if let profile = profile {
			ZStack {
				if let avatarUrl = profile.avatarUrl {
					ImageItemView(imageUrl: avatarUrl, width: 200, height: 200)
						.clipShape(RoundedRectangle(cornerRadius: 12))
						.blur(radius: 5)
				}
				
				VStack {
					Spacer()
					
					Text(profile.name)
						.font(.title2)
						.bold()
					
					Text(profile.role)
						.opacity(0.6)
					
					Button {
						isConfirmaionPresented = true
					} label: {
						Text("Log Out")
							.frame(maxWidth: .infinity)
					}
					.buttonStyle(.glass)
					.confirmationDialog(
						"Delete",
						isPresented: $isConfirmaionPresented
					) {
						Button("Remove", role: .destructive) {
							onLogOutTap()
						}
						.buttonStyle(.bordered)
					} message: {
						Text("This will delete the saved API Key, which results in the lost of account specific access. The deleted API Key cannot be recovered, are you sure?")
					}
				}
				.padding()
			}
			.frame(width: 200, height: 200)
		} else {
			VStack(spacing: 14) {
				Text("Input your API Key")
					.font(.title2)
					.bold()
				
				Text("Please log in and go to https://www.waifu.im/api-keys to create and get your API Key.")
				
				TextField("Your API Key...", text: $inputText)
					.padding(.horizontal, 12)
					.padding(.vertical, 8)
					.background(Color(uiColor: .tertiarySystemFill))
					.clipShape(RoundedRectangle(cornerRadius: 8))
				
				Button {
					onSaveTap(inputText)
					inputText = ""
				} label: {
					Text("Log In")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.glassProminent)
			}
			.padding(30)
			.frame(width: 400, height: 250)
		}
	}
}

#Preview("Logged In") {
	AccountView(onSaveTap: { _ in }, onLogOutTap: {}, profile: ResponseProfile.mock)
		.border(.blue)
}


#Preview("Not Logged In") {
	AccountView(onSaveTap: { _ in }, onLogOutTap: {})
		.border(.blue)
}

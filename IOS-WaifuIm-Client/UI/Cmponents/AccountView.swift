//
//  AccountView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

import SwiftUI

struct AccountView: View {
	let onSaveTap: (String) -> Void
	var profile: ResponseProfile? = nil
	
	@State private var inputText: String = ""
	
    var body: some View {
		if let profile = profile {
			VStack {
				Text(profile.name)
			}
			.padding()
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
					Text("Save API Key")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.glassProminent)
			}
			.padding()
			.frame(width: 400, height: 250)
		}
    }
}

#Preview("Logged In") {
	AccountView(onSaveTap: { _ in }, profile: ResponseProfile.mock)
		.border(.blue)
}


#Preview("Not Logged In") {
	AccountView(onSaveTap: { _ in })
		.border(.blue)
}

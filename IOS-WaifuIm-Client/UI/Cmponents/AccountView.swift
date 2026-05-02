//
//  AccountView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
		VStack {
			Spacer()
			
			Text("Please click the button below to log in with your discord account.")
				.font(.subheadline)
				.multilineTextAlignment(.center)
			
			Spacer()
			
			Button {
				AuthManager.shared.getDiscordOAuthCode()
			} label: {
				Text("Log In")
					.frame(maxWidth: .infinity)
			}
			.buttonStyle(.glass)
		}
    }
}

#Preview {
    AccountView()
		.padding()
		.frame(width: 200, height: 200)
		.border(.blue)
}

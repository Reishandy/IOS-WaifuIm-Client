//
//  AuthManager.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

import SwiftUI
import AuthenticationServices
import CryptoKit

@MainActor
@Observable
class AuthManager: NSObject, ASWebAuthenticationPresentationContextProviding {
	static let shared = AuthManager()
	
	func getDiscordOAuthCode() -> String? {
		let clientID = "1500032398748811314"
		let redirectURI = "discord-1500032398748811314://authorize/callback"
		let scope = "identify"
		
		let codeChallenge = generateCodeChallenge(verifier: generateCodeVerifier())
		
		var components = URLComponents(string: "https://discord.com/api/oauth2/authorize")
		components?.queryItems = [
			URLQueryItem(name: "client_id", value: clientID),
			URLQueryItem(name: "redirect_uri", value: redirectURI),
			URLQueryItem(name: "response_type", value: "code"),
			URLQueryItem(name: "scope", value: scope),
			
			URLQueryItem(name: "code_challenge", value: codeChallenge),
			URLQueryItem(name: "code_challenge_method", value: "S256")
		]
		
		guard let authURL = components?.url else { return nil }
		
		var discordOAuthCode: String? = nil
		let session = ASWebAuthenticationSession(
			url: authURL,
			callbackURLScheme: "discord-1500032398748811314"
		) { callbackURL, error in
			if let error = error {
				print("Auth Error: \(error.localizedDescription)")
				return
			}
			
			if let callbackURL = callbackURL,
			   let components = URLComponents(string: callbackURL.absoluteString),
			   let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
				discordOAuthCode = code
			}
		}
		
		session.presentationContextProvider = self
		session.start()
		
		return discordOAuthCode
	}
	
	func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
		let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
		let activeScene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
		guard let window = activeScene?.windows.first(where: { $0.isKeyWindow }) ?? activeScene?.windows.first else {
			preconditionFailure("Unable to find a valid UIWindowScene to host the login popup.")
		}
		
		return window
	}
	
	private func generateCodeVerifier() -> String {
		var buffer = [UInt8](repeating: 0, count: 32)
		_ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
		return Data(buffer).base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
	}
	
	private func generateCodeChallenge(verifier: String) -> String {
		let data = Data(verifier.utf8)
		let hash = SHA256.hash(data: data)
		return Data(hash).base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
	}
}

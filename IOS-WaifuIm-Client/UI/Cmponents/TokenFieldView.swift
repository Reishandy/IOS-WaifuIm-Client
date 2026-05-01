//
//  TokenFieldView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 01/05/26.
//

import SwiftUI

struct TokenFieldView: View {
	let fieldText: String
	let isNumeric: Bool = false
	
	@Binding var tokens: [String]
	@State private var inputText: String = ""
	
	// TODO: add a list of options use protocol and generics
	
    var body: some View {
		VStack(alignment: .leading) {
			FlowLayout(alignment: .leading, spacing: 8) {
				ForEach(tokens, id: \.self) { token in
					HStack(alignment: .center) {
						Text(token)
							.lineLimit(1)
							.truncationMode(.tail)
						
						Image(systemName: "xmark")
							.font(.caption)
					}
					.padding(.horizontal, 12)
					.padding(.vertical, 8)
					.background(Color(uiColor: .tertiarySystemFill))
					.clipShape(RoundedRectangle(cornerRadius: 8))
					.onTapGesture {
						tokens.removeAll { $0 == token }
					}
					.transition(.scale.combined(with: .opacity))
				}
			}
			
			TextField(fieldText, text: $inputText)
				.keyboardType(isNumeric ? .numberPad : .default)
				.padding(.horizontal, 12)
				.padding(.vertical, 8)
				.background(Color(uiColor: .tertiarySystemFill))
				.clipShape(RoundedRectangle(cornerRadius: 8))
				.onSubmit {
					if !tokens.contains(inputText) {
						tokens.append(inputText)
						inputText = ""
					}
				}
				.onKeyPress(.delete) {
					if inputText.isEmpty && !tokens.isEmpty {
						tokens.removeLast()
						return .handled
					}
					return .ignored
				}
		}
		.animation(.spring, value: tokens)
    }
}

#Preview {
	@Previewable @State var tokens: [String] = [
		"A", "Some Decent long text", "Ayam", "Goreng", "Kucing", "Enak Dimakan"
	]
	
    TokenFieldView(
		fieldText: "Type something",
		tokens: $tokens
	)
}

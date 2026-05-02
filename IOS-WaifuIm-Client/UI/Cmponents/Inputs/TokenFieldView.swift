//
//  TokenFieldView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 01/05/26.
//

import SwiftUI

struct TokenFieldView: View {
	let fieldText: String
	var isNumeric: Bool = false
	var itemOptions: [any TokenDisplayable]? = nil
	
	@Binding var tokens: [String]
	@State private var inputText: String = ""
	@State private var fieldWidth: CGFloat = 0
	@FocusState private var isFieldFocused: Bool
	@State private var shouldShowOptions: Bool = false
	
	private var itemOptionsDict: [String: String] {
		guard let itemOptions = itemOptions else { return [:] }
		
		return Dictionary(uniqueKeysWithValues: itemOptions.map { ($0.token, $0.tokenTitle) })
	}
	
	private var filteredOptions: [any TokenDisplayable] {
		guard let itemOptions = itemOptions else { return [] }
		
		if inputText.isEmpty {
			return itemOptions
		} else {
			return itemOptions.filter { $0.tokenTitle.localizedCaseInsensitiveContains(inputText) }
		}
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			FlowLayout(alignment: .leading, spacing: 8) {
				ForEach(tokens, id: \.self) { token in
					HStack(alignment: .center) {
						Text(itemOptionsDict[token] ?? token)
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
				.focused($isFieldFocused)
				.keyboardType(isNumeric ? .numberPad : .default)
				.padding(.horizontal, 12)
				.padding(.vertical, 8)
				.background(Color(uiColor: .tertiarySystemFill))
				.clipShape(RoundedRectangle(cornerRadius: 8))
				.background(GeometryReader { geo in
					Color.clear.onAppear { fieldWidth = geo.size.width }
				})
				.onSubmit {
					if !tokens.contains(inputText) && itemOptions == nil {
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
				.onChange(of: isFieldFocused) { _, isFocused in
					withAnimation(.spring) {
						shouldShowOptions = isFocused
					}
				}
				.toolbar {
					ToolbarItemGroup(placement: .keyboard) {
						if isNumeric && isFieldFocused {
							Button("Enter") {
								if !tokens.contains(inputText) && itemOptions == nil {
									tokens.append(inputText)
									inputText = ""
								}
								
								isFieldFocused = false
							}
						}
					}
				}
			
			if shouldShowOptions && itemOptions != nil {
				ItemOptionsView(
					parentWidth: fieldWidth,
					filteredOptions: filteredOptions,
					tokens: tokens
				) { token in
					if !tokens.contains(token) {
						tokens.append(token)
					} else {
						tokens.removeAll(where: { $0 == token } )
					}
				}
			}
		}
		.animation(.spring, value: tokens)
		.animation(.spring, value: filteredOptions.count)
	}
}

struct ItemOptionsView: View {
	let parentWidth: CGFloat
	let filteredOptions: [any TokenDisplayable]
	let tokens: [String]
	let onOptionTap: (String) -> Void
	
	var body: some View {
		ScrollView {
			if filteredOptions.isEmpty {
				VStack {
					EmptyStateView(
						iconName: "tray.fill",
						title: "No Options",
						description: "Check your search query",
						isSmall: true
					)
				}
				.frame(height: 200)
				.frame(width: parentWidth)
			} else {
				VStack(alignment: .leading, spacing: 10) {
					ForEach(filteredOptions, id: \.token) { option in
						HStack() {
							VStack(alignment: .leading, spacing: 4) {
								Text(option.tokenTitle)
									.font(.title3)
								
								if let description = option.tokenDescription {
									Text(description)
										.opacity(0.6)
								}
							}
							
							Spacer()
							
							if tokens.contains(option.token) {
								Image(systemName: "checkmark")
							}
						}
						.frame(maxWidth: .infinity)
						.transition(.scale(0.95).combined(with: .opacity))
						.onTapGesture {
							onOptionTap(option.token)
						}
					}
				}
				.padding(16)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		}
		.frame(height: 200)
		.frame(width: parentWidth)
		.glassEffect(.clear, in: RoundedRectangle(cornerRadius: 12))
	}
}

#Preview("No Options") {
	@Previewable @State var tokens: [String] = [
		"A", "Some Decent long text", "Ayam", "Goreng", "Kucing", "Enak Dimakan"
	]
	
	TokenFieldView(
		fieldText: "Type something",
		tokens: $tokens
	)
}

#Preview("With Options") {
	@Previewable @State var tokens: [String] = []
	
	let options: [ResponseTag] = (1...10).map { i in
		ResponseTag(
			id: i,
			name: "Tag \(i)",
			slug: "tag-\(i)",
			description: "Tag \(i) description",
			reviewStatus: "",
			creatorId: i,
			imageCount: i * 10
		)
	}
	
	TokenFieldView(
		fieldText: "Type something",
		itemOptions: options,
		tokens: $tokens
	)
}

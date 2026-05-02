//
//  SizeFilterView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 01/05/26.
//

import SwiftUI

struct SizeFilterView: View {
	let title: String
	@Binding var sizeFilter: SizeFilterType?
	
	@State private var mode: SizeFilterMode = .none
	@State private var value1: String = ""
	@State private var value2: String = ""
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text(title)
				.font(.headline)
				.foregroundStyle(.secondary)
			
			HStack(spacing: 12) {
				Picker("Mode", selection: $mode) {
					ForEach(SizeFilterMode.allCases) { m in
						Text(m.rawValue).tag(m)
					}
				}
				.pickerStyle(.menu)
				.tint(.primary)
				.frame(minWidth: 90)
				.frame(height: 23)
				.padding(.vertical, 8)
				.background(Color(uiColor: .tertiarySystemFill))
				.clipShape(RoundedRectangle(cornerRadius: 8))
				
				if mode != .none {
					TextField(mode == .range ? "Min" : "Value", text: $value1)
						.keyboardType(.numberPad)
						.padding(.horizontal, 12)
						.padding(.vertical, 8)
						.background(Color(uiColor: .tertiarySystemFill))
						.clipShape(RoundedRectangle(cornerRadius: 8))
						.onChange(of: value1) { syncToBinding() }
					
					if mode == .range {
						Text("-")
							.foregroundStyle(.secondary)
						
						TextField("Max", text: $value2)
							.keyboardType(.numberPad)
							.padding(.horizontal, 12)
							.padding(.vertical, 8)
							.background(Color(uiColor: .tertiarySystemFill))
							.clipShape(RoundedRectangle(cornerRadius: 8))
							.onChange(of: value2) { syncToBinding() }
					}
				} else {
					Spacer()
				}
			}
		}
		.onChange(of: mode) {
			if mode == .none {
				value1 = ""
				value2 = ""
			}
			syncToBinding()
		}
		.onChange(of: sizeFilter) { oldValue, newValue in
			if newValue == nil && mode != .none {
				mode = .none
				value1 = ""
				value2 = ""
			}
		}
		.onAppear {
			loadInitialState()
		}
	}
	
	private func syncToBinding() {
		if mode == .none {
			sizeFilter = nil
			return
		}
		
		let v1 = Int(value1)
		let v2 = Int(value2)
		
		switch mode {
		case .exact:
			sizeFilter = v1.map { .exact($0) }
		case .min:
			sizeFilter = v1.map { .min($0) }
		case .max:
			sizeFilter = v1.map { .max($0) }
		case .range:
			if let v1 = v1, let v2 = v2, v2 > v1 {
				sizeFilter = .range(v1, v2)
			} else {
				sizeFilter = nil
			}
		case .none:
			break
		}
	}
	
	private func loadInitialState() {
		guard let filter = sizeFilter else {
			mode = .none
			return
		}
		
		switch filter {
		case .exact(let v):
			mode = .exact
			value1 = String(v)
		case .min(let v):
			mode = .min
			value1 = String(v)
		case .max(let v):
			mode = .max
			value1 = String(v)
		case .range(let minV, let maxV):
			mode = .range
			value1 = String(minV)
			value2 = String(maxV)
		}
	}
}

#Preview {
	SizeFilterView(title: "Size", sizeFilter: .constant(.range(100, 100)))
}

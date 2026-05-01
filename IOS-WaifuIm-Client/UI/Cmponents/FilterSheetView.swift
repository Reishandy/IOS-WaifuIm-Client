//
//  FilterSheetView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct FilterSheetView: View {
	@Binding var filterState: FilterState
	let onDismissPress: () -> Void
	let onApplyPress: () -> Void
	
    var body: some View {
		ZStack(alignment: .topTrailing) {
			FilterView(filterState: $filterState)
			
			VStack(alignment: .trailing) {
				Button {
					onDismissPress()
				} label: {
					Image(systemName: "xmark")
						.font(.title2)
						.padding(.vertical, 4)
				}
				.buttonStyle(.glass)
				
				Spacer()
				
				HStack {
					if filterState != FilterState.defultFilter {
						Button {
							filterState = FilterState.defultFilter
						} label: {
							Text("Reset")
								.padding(.vertical, 4)
								.padding(.horizontal, 12)
						}
						.buttonStyle(.glass)
						.transition(.move(edge: .leading).combined(with: .opacity))
					}
					
					Spacer()
					
					Button {
						onApplyPress()
					} label: {
						Text("Apply")
							.padding(.vertical, 4)
							.padding(.horizontal, 12)
					}
					.buttonStyle(.glassProminent)
				}
				.padding(.bottom, -20)
			}
			.padding(10)
		}
		.padding(10)
		.animation(.spring, value: filterState)
    }
}

#Preview {
	@Previewable @State var isSheetPresented: Bool = true
	
	VStack {
		Button("toggle sheet") {
			isSheetPresented = true
		}
		.buttonStyle(.glassProminent)
	}
	.sheet(isPresented: $isSheetPresented) {
		FilterSheetView(
			filterState: .constant(FilterState.defultFilter),
			onDismissPress: {
				isSheetPresented = false
			},
			onApplyPress: {}
		)
	}
}

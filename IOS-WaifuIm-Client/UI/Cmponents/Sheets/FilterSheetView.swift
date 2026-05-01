//
//  FilterSheetView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

import SwiftUI

struct FilterSheetView: View {
	@Binding var filterState: FilterState
	let onApplyPress: () -> Void
	
    var body: some View {
		ZStack() {
			ScrollView {
				FilterView(filterState: $filterState)
				
				Color.clear
					.frame(height: 40)
			}
			
			VStack(alignment: .trailing) {
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
						Text("Done")
							.padding(.vertical, 4)
							.padding(.horizontal, 12)
					}
					.buttonStyle(.glassProminent)
				}
				.padding(.bottom, -20)
			}
			.padding(10)
		}
		.animation(.spring, value: filterState)
		.interactiveDismissDisabled()
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
			onApplyPress: {
				isSheetPresented = false
			}
		)
		.environment(AppManager())
	}
}

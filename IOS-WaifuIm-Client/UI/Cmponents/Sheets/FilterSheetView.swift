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
	let onCancelPress: () -> Void
	
    var body: some View {
		ZStack() {
			ScrollView {
				FilterView(filterState: $filterState)
				
				Color.clear
					.frame(height: filterState != FilterState.defultFilter ? 130 : 80)
			}
			
			VStack(alignment: .trailing) {
				Spacer()
				
				HStack(alignment: .bottom) {
					VStack(alignment: .leading) {
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
						
						Button {
							onCancelPress()
						} label: {
							Text("Cancel")
								.padding(.vertical, 4)
								.padding(.horizontal, 12)
						}
						.buttonStyle(.glass)
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
			}
			.padding(35)
		}
		.animation(.spring, value: filterState)
    }
}

#Preview {
	@Previewable @State var isSheetPresented: Bool = true
	@Previewable @State var manager: AppManager = AppManager()
	
	VStack {
		Button("toggle sheet") {
			isSheetPresented = true
		}
		.buttonStyle(.glassProminent)
	}
	.sheet(isPresented: $isSheetPresented) {
		FilterSheetView(
			filterState: $manager.filterState,
			onApplyPress: {
				isSheetPresented = false
			},
			onCancelPress: {
				isSheetPresented = false
			}
		)
		.environment(manager)
	}
}

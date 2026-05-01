//
//  FilterView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 01/05/26.
//

import SwiftUI

struct FilterView: View {
	@Binding var filterState: FilterState
	
    var body: some View {
		ScrollView {
			
		}
    }
}

#Preview {
	FilterView(filterState: .constant(FilterState.defultFilter))
}

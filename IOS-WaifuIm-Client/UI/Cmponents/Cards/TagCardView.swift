//
//  TagCardView.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

import SwiftUI

struct TagCardView: View {
	let responseTag: ResponseTag
	
    var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Text(responseTag.name)
					.font(.title)
					.bold()
				
				Spacer()
				
				Text("\(responseTag.imageCount)")
					.font(.subheadline)
					.opacity(0.5)
				
				Image(systemName: "photo")
					.font(.subheadline)
					.opacity(0.5)
			}
			
			Text(responseTag.description)
				.opacity(0.6)
		}
		.padding(12)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(Color(uiColor: .tertiarySystemFill))
		.clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
	TagCardView(responseTag: ResponseTag.mocks.last!)
}

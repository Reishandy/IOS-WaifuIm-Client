//
//  ResponseImageFetch.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

struct ResponseImageFetch {
	let items: [ResponseImage]
	let pageNumber: Int
	let totalPages: Int
	let totalCount: Int
	let maxPageSize: Int
	let defaultPageSize: Int
	let hasPreviousPage: Bool
	let hasNextPage: Bool
}

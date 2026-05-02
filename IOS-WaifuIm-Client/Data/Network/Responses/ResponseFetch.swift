//
//  ResponseFetch.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 01/05/26.
//

nonisolated struct ResponseFetch<T: APIResponse>: Decodable, APIResponse {
	let items: [T]
	let pageNumber: Int
	let totalPages: Int
	let totalCount: Int
	let maxPageSize: Int
	let defaultPageSize: Int
	let hasPreviousPage: Bool
	let hasNextPage: Bool
	
	static var path: APIPath { T.path }
}

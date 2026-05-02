//
//  ResponseError.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

nonisolated struct ResponseError: Decodable, Equatable {
	let errors: [String: String]?
	let type: String?
	let title: String?
	let status: Int?
	let detail: String?
	let instance: String?
	let traceId: String?
}

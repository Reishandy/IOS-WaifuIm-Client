//
//  ResponseError.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

struct ResponseError {
	let errors: [String: String]?
	let type: String?
	let status: String?
	let detail: String?
	let instance: String?
	let traceId: String?
}

//
//  APIResponse.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 01/05/26.
//

nonisolated protocol APIResponse: Decodable {
	static var path: APIPath { get }
}

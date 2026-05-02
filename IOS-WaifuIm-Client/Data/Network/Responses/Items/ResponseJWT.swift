//
//  ResponseJWT.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 02/05/26.
//

import Foundation

nonisolated struct ResponseJWT: Decodable, APIResponse {
	var string: String
	
	static var path: APIPath {	.jwt }
}

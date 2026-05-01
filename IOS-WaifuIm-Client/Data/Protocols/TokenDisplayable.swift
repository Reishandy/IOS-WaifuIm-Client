//
//  TokenDisplayable.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 01/05/26.
//

protocol TokenDisplayable {
	var token: String { get }
	var tokenTitle: String { get }
	var tokenDescription: String? { get }
}

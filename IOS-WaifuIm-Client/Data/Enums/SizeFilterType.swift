//
//  SizeFilterType.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

enum SizeFilterType {
	case exact(Int)
	case min(Int)
	case max(Int)
	case range(Int, Int)
	
	// TODO: Getter
}

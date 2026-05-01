//
//  SizeFilterType.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

nonisolated enum SizeFilterType: Equatable {
	case exact(Int)
	case min(Int)
	case max(Int)
	case range(Int, Int)
	
	var stringValue: String {
		switch self {
		case .exact(let value):
			return "\(value)"
		case .min(let value):
			return ">=\(value)"
		case .max(let value):
			return "<=\(value)"
		case .range(let minValue, let maxValue):
			return "\(minValue)..\(maxValue)"
		}
	}
}

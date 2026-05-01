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

enum SizeFilterMode: String, CaseIterable, Identifiable {
	case none = "None"
	case exact = "Exact"
	case min = "Min"
	case max = "Max"
	case range = "Range"
	var id: Self { self }
}

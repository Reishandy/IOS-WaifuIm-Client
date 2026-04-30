//
//  FilterState.swift
//  IOS-WaifuIm-Client
//
//  Created by Muhammad Akbar Reishandy on 30/04/26.
//

struct FilterState {
	var isNsfw: BooleanFilterType
	var includedTags: [String]
	var excludedTags: [String]
	var IncludedArtists: [String]
	var excludedArtiests: [String]
	var IncludedIds: [String]
	var excludedIds: [String]
	var isAnimated: BooleanFilterType
	var orderBy: OrderByFilterType
	var orientation: OrientationFilterType
	var page: Int
	var pageSize: Int
	var width: SizeFilterType?
	var height: SizeFilterType?
	var byteSize: Int?
}

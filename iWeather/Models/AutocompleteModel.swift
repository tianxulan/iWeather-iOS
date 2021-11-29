//
//  AutocompleteModel.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/28/21.
//

import Foundation
struct AutocompleteData: Decodable
{
    let description: String
    let name: String
}
struct AutocompleteModel
{
    var placeCells: Array<AutocompleteCellModel>
}
struct AutocompleteCellModel
{
    let cityDescription: String
    let cityName: String
}

//
//  LastFmPeriod.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import Foundation

public enum LastFmPeriod: String, Codable, Equatable {
    case overall
    case week = "7day"
    case month = "1month"
    case quarter = "3month"
    case halfYear = "6month"
    case year = "12month"
}

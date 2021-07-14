//
//  LastFmImage.swift
//  
//
//  Created by Adam Różyński on 13/05/2021.
//

import Foundation


public struct LastFmImage: Codable, Equatable {
    
    public let size: Size
    public let url: URL
    
    public enum Size: String, Codable, Equatable {
        case small
        case medium
        case large
        case extraLarge = "extralarge"
    }
    
}

extension LastFmImage {
    
    enum CodingKeys: String, CodingKey {
        case size
        case url = "#text" // 🤦‍♂️
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        size = try container.decode(Size.self, forKey: .size)
        url = try container.decode(URL.self, forKey: .url)
    }
    
}

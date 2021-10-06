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

        var semanticRep: Int {
            switch self {
            case .extraLarge:
                return 4
            case .large:
                return 3
            case .medium:
                return 2
            case .small:
                return 1
            }
        }
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

public extension Array where Element == LastFmImage {
    var highestPossibleQualityImage: LastFmImage? {
        var result: LastFmImage? = nil
        for image in self {
            if let currentResult = result,
               currentResult.size.semanticRep < image.size.semanticRep {
                result = image
            } else if result == nil {
                result = image
            }
        }
        return result
    }

    var lowestPossibleQualityImage: LastFmImage? {
        var result: LastFmImage? = nil
        for image in self {
            if let currentResult = result,
               currentResult.size.semanticRep > image.size.semanticRep {
                result = image
            } else if result == nil {
                result = image
            }
        }
        return result
    }
}

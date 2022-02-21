//
//  LastFmImage.swift
//  
//
//  Created by Adam Różyński on 13/05/2021.
//

import Foundation


public struct LastFmImage: Codable, Equatable {
    public let size: Size
    public let url: URL?
    
    public enum Size: String, Codable, Equatable {
        case small
        case medium
        case large
        case extraLarge = "extralarge"
        case mega
        case fallback = ""

        var semanticRep: Int {
            switch self {
            case .mega:
                return 5
            case .extraLarge:
                return 4
            case .large:
                return 3
            case .medium:
                return 2
            case .small:
                return 1
            default:
                return 0
            }
        }
    }

    public init(size: LastFmImage.Size, url: URL) {
        self.size = size
        self.url = url
    }

}

extension LastFmImage {
    
    enum CodingKeys: String, CodingKey {
        case size
        case url = "#text" // 🤦‍♂️
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        size = try container.decode(Size?.self, forKey: .size) ?? .fallback
        if let urlString = try container.decodeIfPresent(String.self, forKey: .url), let url = URL(string: urlString) {
            self.url = url
        } else {
            self.url = nil
        }
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

//
//  LoadStub.swift
//  
//
//  Created by Adam Różyński on 01/05/2021.
//

import Foundation

/// named execatly as a file in Resources
enum FileName: String {
    case userSessionResponse
    case errorResponse
    case errorWithUnknownCodeResponse
    case scrobbleResponse
    case userInfoResponse
    case emptyResponse
    case userInfoWithoutAvatarResponse
    case extendedRecentTracksResponse
    case similarTracksResponse
    case similarTrack
}

extension Data {
    static func dataFrom(_ fileName: FileName) -> Data {
        let url = Bundle.module.url(forResource: fileName.rawValue, withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}

func responseMock<Resource: Codable>(for fileName: FileName, expectedType: Resource.Type) throws -> Resource {
    let decoder = JSONDecoder()
    let data = Data.dataFrom(fileName)
    return try decoder.decode(expectedType, from: data)
}

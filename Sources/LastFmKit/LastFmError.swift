//
//  LastFmError.swift
//  
//
//  Created by Adam Różyński on 01/05/2021.
//

import Foundation

struct LastFmError: Error, Codable {
    let error: Code?
    let message: String

    public enum Code: Int, Codable {
        case invalidService = 2
        case invalidMethod = 3
        case authenticationFailedOrUsePost = 4
        case invalidFormat = 5
        case invalidParameters = 6
        case invalidResource = 7
        case operationFailed = 8
        case invalidSessionKey = 9
        case invalidApiKey = 10
        case serviceOffline = 11
        case invalidMethodSignature = 13
        case tempError = 16
        case suspendedApiKey = 26
        case rateLimitExceeded = 29
    }
}

extension LastFmError {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let errorCode = try container.decode(Int.self, forKey: .error)
        error = Code(rawValue: errorCode)
        message = try container.decode(String.self, forKey: .message)
    }
    
    enum CodingKeys: CodingKey {
        case error
        case message
    }
    
}

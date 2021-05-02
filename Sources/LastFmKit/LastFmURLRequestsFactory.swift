//
//  LastFmURLRequestsFactory.swift
//  
//
//  Created by Adam Różyński on 28/04/2021.
//

import Foundation
import CryptoKit

enum LastFmMethod: String {
    case getMobilSession = "auth.getMobileSession"
    case scrobbleTrack = "track.scrobble"
    
    func queryItem() -> URLQueryItem {
        return URLQueryItem(name: "method", value: rawValue)
    }
}

struct LastFmURLRequestsFactory {
    
    enum RequestError: Error {
        case noQueryItems
        case urlIsNil
        case cannotMakeBody
    }
    
    static func logInUserRequest(withUsername username: String, password: String, apiKey: String, secret: String) throws -> URLRequest {
        var components = commonComponents()
        components.queryItems = [
            LastFmMethod.getMobilSession.queryItem(),
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password)
        ]
        return try requestForComponents(components, apiKey: apiKey, secret: secret, sessionKey: nil)
    }
    
    static func scrobbleTrack(withTitle title: String,
                              byArtist artist: String,
                              albumArtist: String?,
                              scrobbleDate: Date,
                              apiKey: String,
                              secret: String,
                              sessionKey: String) throws -> URLRequest {
        var components = commonComponents()
        components.queryItems = [
            LastFmMethod.scrobbleTrack.queryItem(),
            URLQueryItem(name: "artist", value: artist),
            URLQueryItem(name: "track", value: title),
            URLQueryItem(name: "albumArtist", value: albumArtist),
            URLQueryItem(name: "timestamp", value: "\(scrobbleDate.timeIntervalSince1970)")
        ]
        return try requestForComponents(components, apiKey: apiKey, secret: secret, sessionKey: sessionKey)
    }
    
    static func requestForComponents(_ components: URLComponents,
                                     apiKey: String,
                                     secret: String,
                                     sessionKey: String?) throws -> URLRequest {
        guard var queryItems = components.queryItems else { throw RequestError.noQueryItems }
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        if let key = sessionKey {
            queryItems.append(URLQueryItem(name: "sk", value: key))
        }
        queryItems.append(URLQueryItem(name: "api_sig", value: methodSignature(for: queryItems, secret: secret)))
        queryItems.append(URLQueryItem(name: "format", value: "json"))
        var components = components
        components.queryItems = queryItems
        guard let body = components.query?.data(using: .utf8) else { throw RequestError.cannotMakeBody }
        components.query = nil
        guard let url = components.url else { throw RequestError.urlIsNil }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.httpBody = body
        return request
    }
}

// MARK: Private
extension LastFmURLRequestsFactory {
    static func commonComponents() -> URLComponents {
        return URLComponents(string: "https://ws.audioscrobbler.com/2.0/")!
    }
    
    static func methodSignature(for queryItems: [URLQueryItem], secret: String) -> String {
        // Sort all items by name
        let sortedQueryItems = sortedParams(for: queryItems)
        // Join all pairs of name/value into one string
        let methodSignature = sortedQueryItems.map { "\($0.name)\($0.value ?? "")"}.joined()
        // Append secret
        let methodSignatureWithSecret = methodSignature + secret
        // Serialize
        let data = methodSignatureWithSecret.data(using: .utf8)
        assert(data != nil)
        // Hash
        let digest = Insecure.MD5.hash(data: data ?? Data())
        return digest.hexString()
    }
    
    static func sortedParams(for queryItems: [URLQueryItem]) -> [URLQueryItem] {
        return queryItems.sorted { $0.name < $1.name }
    }
}

extension Insecure.MD5Digest {
    /// changes digest into hex string
    func hexString() -> String {
        return self.map { String(format: "%02hhx", $0) }.joined()
    }
}

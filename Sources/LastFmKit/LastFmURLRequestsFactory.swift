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
    case loveTrack = "track.love"
    case unloveTrack = "track.unlove"
    
    func queryItem() -> URLQueryItem {
        return URLQueryItem(name: "method", value: rawValue)
    }
}

struct LastFmURLRequestsFactory {
    
    static func logInUserRequest(withUsername username: String, password: String, apiKey: String, secret: String) -> URLRequest {
        var components = commonComponents()
        components.queryItems = [
            LastFmMethod.getMobilSession.queryItem(),
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password)
        ]
        return requestForComponents(components, apiKey: apiKey, secret: secret, sessionKey: nil)
    }
    
    static func scrobbleTrackRequest(withTitle title: String,
                                     byArtist artist: String,
                                     albumArtist: String?,
                                     album: String?,
                                     scrobbleDate: Date,
                                     apiKey: String,
                                     secret: String,
                                     sessionKey: String) -> URLRequest {
        var components = commonComponents()
        var queryItems = [
            LastFmMethod.scrobbleTrack.queryItem(),
            URLQueryItem(name: "artist", value: artist),
            URLQueryItem(name: "track", value: title),
            URLQueryItem(name: "timestamp", value: "\(scrobbleDate.timeIntervalSince1970)")
        ]
        if let album = album {
            queryItems.append(URLQueryItem(name: "album", value: album))
        }
        if let albumArtist = albumArtist {
            queryItems.append(URLQueryItem(name: "albumArtist", value: albumArtist))
        }
        components.queryItems = queryItems
        return requestForComponents(components, apiKey: apiKey, secret: secret, sessionKey: sessionKey)
    }
    
    static func loveTrackRequest(withTitle title: String,
                                 byArtist artist: String,
                                 apiKey: String,
                                 secret: String,
                                 sessionKey: String) -> URLRequest {
        var components = commonComponents()
        components.queryItems = [
            LastFmMethod.loveTrack.queryItem(),
            URLQueryItem(name: "artist", value: artist),
            URLQueryItem(name: "track", value: title)
        ]
        return requestForComponents(components, apiKey: apiKey, secret: secret, sessionKey: sessionKey)
    }
    
    static func unloveTrackRequest(withTitle title: String,
                                   byArtist artist: String,
                                   apiKey: String,
                                   secret: String,
                                   sessionKey: String) -> URLRequest {
        var components = commonComponents()
        components.queryItems = [
            LastFmMethod.unloveTrack.queryItem(),
            URLQueryItem(name: "artist", value: artist),
            URLQueryItem(name: "track", value: title)
        ]
        return requestForComponents(components, apiKey: apiKey, secret: secret, sessionKey: sessionKey)
    }
    
}

// MARK: Private
extension LastFmURLRequestsFactory {
    
    private static func requestForComponents(_ components: URLComponents,
                                             apiKey: String,
                                             secret: String,
                                             sessionKey: String?) -> URLRequest {
        assert((components.queryItems?.count ?? 0) > 0)
        assert(components.queryItems?.compactMap { $0.value }.count == components.queryItems?.count)
        var queryItems = components.queryItems!
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        if let key = sessionKey {
            queryItems.append(URLQueryItem(name: "sk", value: key))
        }
        queryItems.append(URLQueryItem(name: "api_sig", value: methodSignature(for: queryItems, secret: secret)))
        queryItems.append(URLQueryItem(name: "format", value: "json"))
        var components = components
        components.queryItems = queryItems
        // we'll always have the query so it's safe to unwrap it here
        let body = components.percentEncodedQuery!.data(using: .utf8)
        components.query = nil
        // we'll always generate the URL (hopefully :D)
        var request = URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.httpBody = body
        return request
    }
    
    internal static func commonComponents() -> URLComponents {
        return URLComponents(string: "https://ws.audioscrobbler.com/2.0/")!
    }
    
    private static func methodSignature(for queryItems: [URLQueryItem], secret: String) -> String {
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
    
    internal static func sortedParams(for queryItems: [URLQueryItem]) -> [URLQueryItem] {
        return queryItems.sorted { $0.name < $1.name }
    }
}

extension Insecure.MD5Digest {
    /// changes digest into hex string
    func hexString() -> String {
        return self.map { String(format: "%02hhx", $0) }.joined()
    }
}

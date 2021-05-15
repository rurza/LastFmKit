//
//  LastFmClient.swift
//  
//
//  Created by Adam Różyński on 28/04/2021.
//

import Foundation
import Combine

public protocol LastFmClientCacheProvider: AnyObject {
    func cachedResponseForRequest<Resource: Codable>(_ request: URLRequest) -> Resource?
    func saveResponse<Resource: Codable>(_ response: Resource, forRequest req: URLRequest)
}

public struct LastFmClient {

    public let secret: String
    public let apiKey: String
    public var sessionKey: String?
    public weak var cacheProvider: LastFmClientCacheProvider?
    
    public var dataTaskPublisher: (URLRequest) -> AnyPublisher<Data, URLError>
    
    public init(secret: String,
                apiKey: String,
                sessionKey: String? = nil,
                urlSession: URLSession = URLSession(configuration: .default),
                cacheProvider: LastFmClientCacheProvider? = nil) {
        self.secret = secret
        self.apiKey = apiKey
        self.sessionKey = sessionKey
        self.cacheProvider = cacheProvider
        dataTaskPublisher = { request in
            urlSession.dataTaskPublisher(for: request).map(\.data).eraseToAnyPublisher()
        }
    }
    
    
    public func logInUser(_ username: String, password: String)
    -> AnyPublisher<LastFmSession, Error> {
        let request = LastFmURLRequestsFactory.logInUserRequest(withUsername: username,
                                                                     password: password,
                                                                     apiKey: apiKey,
                                                                     secret: secret)
        return makeRequestPublisher(request, useCache: false)
    }
    
    public func scrobbleTrack(_ track: String,
                              byArtist artist: String,
                              albumArtist: String?,
                              album: String?,
                              scrobbleDate: Date = Date())
    throws -> AnyPublisher<LastFmScrobbleTrackResponse, Error> {
        guard let sessionKey = sessionKey else { throw ClientError.sessionKeyNotSet }
        let request = LastFmURLRequestsFactory.scrobbleTrackRequest(withTitle: track,
                                                             byArtist: artist,
                                                             albumArtist: albumArtist,
                                                             album: album,
                                                             scrobbleDate: scrobbleDate,
                                                             apiKey: apiKey,
                                                             secret: secret,
                                                             sessionKey: sessionKey)
        return makeRequestPublisher(request, useCache: false)
    }
    
    public func loveTrack(_ track: String, byArtist artist: String) throws -> AnyPublisher<Void, Error> {
        guard let sessionKey = sessionKey else { throw ClientError.sessionKeyNotSet }
        let request = LastFmURLRequestsFactory.loveTrackRequest(withTitle: track, byArtist: artist, apiKey: apiKey, secret: secret, sessionKey: sessionKey)
        return makeRequestPublisher(request, useCache: false)
            .map { (empty: VoidCodable) -> Void in return }
            .eraseToAnyPublisher()
    }
    
    public func unloveTrack(_ track: String, byArtist artist: String) throws -> AnyPublisher<Void, Error> {
        guard let sessionKey = sessionKey else { throw ClientError.sessionKeyNotSet }
        let request = LastFmURLRequestsFactory.unloveTrackRequest(withTitle: track, byArtist: artist, apiKey: apiKey, secret: secret, sessionKey: sessionKey)
        return makeRequestPublisher(request, useCache: false)
            .map { (empty: VoidCodable) -> Void in return }
            .eraseToAnyPublisher()
    }
    
    public func getUserInfo(_ username: String) throws -> AnyPublisher<LastFmUserInfo, Error> {
        let request = LastFmURLRequestsFactory.getUserInfo(username, apiKey: apiKey, secret: secret)
        return makeRequestPublisher(request, useCache: false)
    }
    
    
}

private extension LastFmClient {
    
    func makeRequestPublisher<Resource>(_ request: URLRequest, useCache: Bool = false)
    -> AnyPublisher<Resource, Error> where Resource: Codable {
        if let r = cacheProvider?.cachedResponseForRequest(request) as Resource?, useCache {
            return Future<Resource, Error> { future in
                future(.success(r))
            }.eraseToAnyPublisher()
        }
        let decoder = JSONDecoder()
        return dataTaskPublisher(request)
            .tryMap { data in
                if let serviceError = try? decoder.decode(LastFmError.self, from: data) {
                    throw serviceError
                }
                return data
            }
            .decode(type: Resource.self, decoder: decoder)
            .map {
                self.cacheProvider?.saveResponse($0, forRequest: request)
                return $0
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

// MARK: - Error
public extension LastFmClient {
    enum ClientError: Error {
        case sessionKeyNotSet
    }
}

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

public class LastFmClient {

    public let secret: String
    public let apiKey: String
    public var sessionKey: String?
    public weak var cacheProvider: LastFmClientCacheProvider?
    
    private let session: URLSession
    private lazy var jsonDecoder = JSONDecoder()
    public var dataTaskPublisher: ((URLRequest) -> AnyPublisher<Data, URLError>)!
    
    public init(secret: String,
                apiKey: String,
                sessionKey: String? = nil,
                urlSession: URLSession = URLSession(configuration: .default),
                cacheProvider: LastFmClientCacheProvider? = nil) {
        self.secret = secret
        self.apiKey = apiKey
        self.sessionKey = sessionKey
        self.cacheProvider = cacheProvider
        self.session = urlSession
        dataTaskPublisher = { request in
            urlSession.dataTaskPublisher(for: request).map(\.data).eraseToAnyPublisher()
        }
    }
    
    
    public func logInUser(_ username: String, password: String)
    -> AnyPublisher<LastFmSession, Error> {
        let request = try! LastFmURLRequestsFactory.logInUserRequest(withUsername: username,
                                                                     password: password,
                                                                     apiKey: apiKey,
                                                                     secret: secret)
        return makeRequestPublisher(request, useCache: false)
    }
    
    public func scrobbleTrack(_ track: String,
                              byArtist artist: String,
                              albumArtist: String?,
                              scrobbleDate: Date = Date())
    throws -> AnyPublisher<LastFmSession, Error> {
        guard let sessionKey = sessionKey else { throw ClientError.sessionKeyNotSet }
        let request = try LastFmURLRequestsFactory.scrobbleTrack(withTitle: track,
                                                                 byArtist: artist,
                                                                 albumArtist: albumArtist,
                                                                 scrobbleDate: scrobbleDate,
                                                                 apiKey: apiKey,
                                                                 secret: secret,
                                                                 sessionKey: sessionKey)
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
        return dataTaskPublisher(request)
            .tryMap { [self] data in
                print(String(data: data, encoding: .utf8)!)
                if let serviceError = try? jsonDecoder.decode(LastFmError.self, from: data) {
                    throw serviceError
                }
                return data
            }
            .decode(type: Resource.self, decoder: jsonDecoder)
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

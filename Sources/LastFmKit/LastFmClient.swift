//
//  LastFmClient.swift
//  
//
//  Created by Adam Różyński on 28/04/2021.
//

import Foundation

public protocol LastFmClientCacheProvider: AnyObject {
    func cachedResponseForRequest<Resource: Codable>(_ request: URLRequest) -> LastFmResponse<Resource>?
    func saveResponse<Resource: Codable>(_ response: LastFmResponse<Resource>, forRequest req: URLRequest)
}

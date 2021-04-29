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
    
    func queryItem() -> URLQueryItem {
        return URLQueryItem(name: "method", value: rawValue)
    }
}

struct LastFmURLRequestsFactory {
    
//    static func getSession(with apiKey: String, username: String, password: String) -> URLRequest {
//        var components = commonComponents()
//        components.queryItems = [
//            LastFmMethod.getMobilSession.queryItem(),
//            URLQueryItem(name: "username", value: username),
//            URLQueryItem(name: "password", value: password)
//        ]
//    }
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

func mver<S, A>(
    _ setter: (@escaping (inout A) -> Void) -> (inout S) -> Void,
    _ set: @escaping (inout A) -> Void
) -> (inout S) -> Void {
    return setter(set)
}

//func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>) -> (@escaping (Value) -> Value) -> (Root) -> Root {
//    return { update in
//        return { root in
//            var root = root
//            root[keyPath: kp] = update(root[keyPath: kp])
//            return root
//        }
//    }
//}

func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>) -> (@escaping (inout Value) -> Void) -> (inout Root) -> Void {
    return { update in
        return { root in
            update(&root[keyPath: kp])
        }
        
    }
}

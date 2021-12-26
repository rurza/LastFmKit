//
//  LastFmURLRequestsFactoryTests.swift
//  
//
//  Created by Adam Różyński on 28/04/2021.
//

@testable import LastFmKit
import XCTest

final class LastFmURLRequestsFactoryTests: XCTestCase {
    
    let secret = "secret"
    let apiKey = "stupidApiKey"
//    let session = "last_fm_session"
    let sessionKey = "t9q4raia2sl2_YwDBaQ2-f_dCXjGV-44"
    
    func testCommonURLComponents() throws {
        let components = LastFmURLRequestsFactory.commonComponents()
        XCTAssertEqual(components.scheme, "https")
        XCTAssertEqual(components.host, "ws.audioscrobbler.com")
        XCTAssertEqual(components.path, "/2.0/")
        XCTAssertNotNil(components.url)
        XCTAssertNil(components.queryItems)
    }
    
    func testSortingQueryItems() throws {
        let zItem = URLQueryItem(name: "z", value: "1")
        let aItem = URLQueryItem(name: "a", value: "2")
        let queryItems = [zItem,
                          aItem,
                          URLQueryItem(name: "y", value: "3"),
                          URLQueryItem(name: "b", value: "4")]
        let sortedQueryItems = LastFmURLRequestsFactory.sortedParams(for: queryItems)
        XCTAssertEqual(sortedQueryItems.first, aItem)
        XCTAssertEqual(sortedQueryItems.last, zItem)
    }
    
    func testGetSessionRequest() throws {
        let username = "username"
        let password = "pass"
        let request = LastFmURLRequestsFactory.logInUserRequest(withUsername: username,
                                                                password: password,
                                                                apiKey: apiKey,
                                                                secret: secret)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        let body = String(data: request.httpBody!, encoding: .utf8)
        XCTAssertEqual(body, "method=\(LastFmMethod.getMobilSession.rawValue)&username=\(username)&password=\(password)&api_key=\(apiKey)&api_sig=6ced8ef5e2da8bd6d48b73589ad5da2c&format=json")
    }
    
    func testScrobbleTrackRequest() throws {
        let characterSet = CharacterSet.urlQueryAllowed
        let track = "10,000 Days (Wings Part 2)"
        let artist = "Tool"
        let albumArtist = "Tool"
        let album = "10,000 Days"
        let date = Date()
        let request = LastFmURLRequestsFactory.scrobbleTrackRequest(withTitle: track,
                                                                 byArtist: artist,
                                                                 albumArtist: albumArtist,
                                                                 album: track,
                                                                 scrobbleDate: date,
                                                                 apiKey: apiKey,
                                                                 secret: secret,
                                                                 sessionKey: sessionKey)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        let body = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("method=\(LastFmMethod.scrobbleTrack.rawValue)"))
        XCTAssertTrue(body.contains("artist=\(artist.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("track=\(track.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("albumArtist=\(albumArtist.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("timestamp=\(date.timeIntervalSince1970)"))
        XCTAssertTrue(body.contains("api_key=\(apiKey)"))
        XCTAssertTrue(body.contains("sk=\(sessionKey)"))
        XCTAssertTrue(body.contains("album=\(album.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
    }
    
    func testLoveTrackRequest() throws {
        let characterSet = CharacterSet.urlQueryAllowed
        let track = "Piano Concerto in A Minor, Op. 54: II. Intermezzo - Andante grazioso"
        let artist = "マリアン・ラプサンスキー/スロヴァキア・フィルハーモニー管弦楽団/ビストリク・レジュハ"
        let request = LastFmURLRequestsFactory.loveTrackRequest(withTitle: track, byArtist: artist, apiKey: apiKey, secret: secret, sessionKey: sessionKey)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        let body = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("method=\(LastFmMethod.loveTrack.rawValue)"))
        XCTAssertTrue(body.contains("artist=\(artist.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("track=\(track.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("api_key=\(apiKey)"))
        XCTAssertTrue(body.contains("sk=\(sessionKey)"))
    }
    
    func testUnloveTrackRequest() throws {
        let characterSet = CharacterSet.urlQueryAllowed
        let track = "PréLude à L'aprèS-Midi D'un Faune (Afternoon of a Faun)"
        let artist = "Austrian Radio Symphony Orchestra, Milan Horvat"
        let request = LastFmURLRequestsFactory.unloveTrackRequest(withTitle: track, byArtist: artist, apiKey: apiKey, secret: secret, sessionKey: sessionKey)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        let body = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("method=\(LastFmMethod.unloveTrack.rawValue)"))
        XCTAssertTrue(body.contains("artist=\(artist.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("track=\(track.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("api_key=\(apiKey)"))
        XCTAssertTrue(body.contains("sk=\(sessionKey)"))
    }
    
    func testGetUserInfoRequest() throws {
        let username = "rurzynski"
        let request = LastFmURLRequestsFactory.getUserInfo("rurzynski", apiKey: apiKey, secret: secret)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        let body = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("method=\(LastFmMethod.getUserInfo.rawValue)"))
        XCTAssertTrue(body.contains("user=\(username)"))
    }

    func testUpdateNowPlayingRequest() throws {
        let characterSet = CharacterSet.urlQueryAllowed
        let track = "Suite from ''Hymn of the Highlands'': Lairg Muir"
        let artist = "Osamu TAKAHASHI Kiyotaka Noda"
        let request = LastFmURLRequestsFactory.updateNowPlaying(withTitle: track, byArtist: artist, album: nil, apiKey: apiKey, secret: secret, sessionKey: sessionKey)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        let body = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("method=\(LastFmMethod.updateNowPlaying.rawValue)"))
        XCTAssertTrue(body.contains("artist=\(artist.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("track=\(track.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("api_key=\(apiKey)"))
        XCTAssertTrue(body.contains("sk=\(sessionKey)"))
    }
    
    func testUpdateNowPlayingWithAlbumRequest() throws {
        let characterSet = CharacterSet.urlQueryAllowed
        let track = "Suite from ''Hymn of the Highlands'': Lairg Muir"
        let artist = "Osamu TAKAHASHI Kiyotaka Noda"
        let album = "Ode for Trumpet"
        let request = LastFmURLRequestsFactory.updateNowPlaying(withTitle: track, byArtist: artist, album: album, apiKey: apiKey, secret: secret, sessionKey: sessionKey)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        let body = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("method=\(LastFmMethod.updateNowPlaying.rawValue)"))
        XCTAssertTrue(body.contains("artist=\(artist.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("track=\(track.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("album=\(album.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("api_key=\(apiKey)"))
        XCTAssertTrue(body.contains("sk=\(sessionKey)"))
    }

    func testGetRecentTrackRequest() throws {
        let user = "rurzynski"
        let fromDate = Date(timeIntervalSinceNow: -60*60*24*7)
        let toDate = Date()
        let limit = 100
        let request = LastFmURLRequestsFactory.getRecentTracks(fromUser: user, limit: limit, page: 1, extendedInfo: true, fromDate: fromDate, toDate: toDate, apiKey: apiKey, secret: secret)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        let body = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("api_key=\(apiKey)"))
        XCTAssertTrue(body.contains("method=\(LastFmMethod.getRecentTracks.rawValue)"))
        XCTAssertTrue(body.contains("from=\(fromDate.timeIntervalSince1970)"))
        XCTAssertTrue(body.contains("to=\(toDate.timeIntervalSince1970)"))
        XCTAssertTrue(body.contains("user=\(user)"))
        XCTAssertTrue(body.contains("extended=\(1)"))
        XCTAssertTrue(body.contains("limit=\(limit)"))
        XCTAssertTrue(body.contains("page=\(1)"))
    }
    
    func testGetSimilarArtistsRequest() throws {
        let artist = "Tool"
        let limit = 10
        let request = LastFmURLRequestsFactory.getSimilarArtists(toArtist: artist, limit: limit, apiKey: apiKey, secret: secret)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        let body = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("api_key=\(apiKey)"))
        XCTAssertTrue(body.contains("method=\(LastFmMethod.getSimilarArtists.rawValue)"))
        XCTAssertTrue(body.contains("limit=\(limit)"))
        XCTAssertTrue(body.contains("artist=\(artist)"))
    }

    func testGetSimilarTracksRequest() throws {
        let artist = "Danger Mouse"
        let limit = 5
        let track = "Season's Trees (feat. Norah Jones)"
        let request = LastFmURLRequestsFactory.getSimilarTracks(toTitle: track, byArtist: artist, limit: limit, apiKey: apiKey, secret: secret)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        let body = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("api_key=\(apiKey)"))
        XCTAssertTrue(body.contains("method=\(LastFmMethod.getSimilarTracks.rawValue)"))
        XCTAssertTrue(body.contains("limit=\(limit)"))
        let characterSet = CharacterSet.urlQueryAllowed
        XCTAssertTrue(body.contains("artist=\(artist.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
        XCTAssertTrue(body.contains("track=\(track.addingPercentEncoding(withAllowedCharacters: characterSet)!)"))
    }
    
    func testGetTopArtistsRequest() throws {
        let limit = 5
        let username = "rurzynski"
        let request = LastFmURLRequestsFactory.getTopArtists(ofUser: username, period: .month, limit: limit, apiKey: apiKey, secret: secret)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        let body = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("api_key=\(apiKey)"))
        XCTAssertTrue(body.contains("method=\(LastFmMethod.getTopArtists.rawValue)"))
        XCTAssertTrue(body.contains("limit=\(limit)"))
        XCTAssertTrue(body.contains("user=\(username)"))
    }
}

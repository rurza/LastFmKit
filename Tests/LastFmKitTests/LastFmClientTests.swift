//
//  LastFmClientTests.swift
//  
//
//  Created by Adam Różyński on 01/05/2021.
//

@testable import LastFmKit
import XCTest
import Combine

final class LastFmClientTests: XCTestCase {
    
    var client: LastFmClient!
    var cancellables = Set<AnyCancellable>()
    let decoder = JSONDecoder()
    
    override func setUp() {
        client = LastFmClient(secret: "test-secret", apiKey: "test-apikey")
    }
    
    func testUserLogin() throws {
        let sessionMock = try responseMock(for: .userSessionResponse, expectedType: LastFmSession.self)
        client.dataTaskPublisher = DataTaskPublisherMock.responseFunctionForStub(with: .userSessionResponse)
        client.logInUser("", password: "")
            .sink { completion in
                XCTAssertTrue(Thread.isMainThread)
                switch completion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                default:
                    ()
                }
            } receiveValue: { session in
                XCTAssertTrue(Thread.isMainThread)
                //based on json stub
                XCTAssertEqual(session.name, sessionMock.name)
                XCTAssertEqual(session.key, sessionMock.key)
            }
            .store(in: &cancellables)
    }
    
    func testClientErrorThrowing() throws {
        client.dataTaskPublisher = DataTaskPublisherMock.responseFunctionForStub(with: .errorResponse)
        /// the called endpoint doesn't matter for this test
        client.logInUser("", password: "")
            .sink { completion in
                switch completion {
                case let .failure(error as LastFmError):
                    XCTAssertEqual(error.error, .authenticationFailedOrUsePost)
                default:
                    XCTFail()
                }
            } receiveValue: { _ in XCTFail() }
            .store(in: &cancellables)
    }
    
}

enum DataTaskPublisherMock {
    static func responseFunctionForStub(with fileName: FileName) -> (URLRequest, Bool) -> AnyPublisher<Data, URLError> {
        return { request, _ in
            return Future { promise in
                promise(.success(Data.dataFrom(fileName)))
            }.eraseToAnyPublisher()
        }
    }
}


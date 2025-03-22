//
//  StubURLProtocol.swift
//  GitFeedTests
//
//  Created by Dat on 18/03/2025.
//

import Foundation

typealias StubAPIResponse = (Data, HTTPURLResponse)

class StubURLProtocol: URLProtocol {
    static var response: StubAPIResponse?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let response = StubURLProtocol.response {
            self.client?.urlProtocol(self, didReceive: response.1, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: response.0)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
    
    static func reset() {
        response = nil
    }
}

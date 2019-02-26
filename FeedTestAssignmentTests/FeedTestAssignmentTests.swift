//
//  PostTestAssignmentTests.swift
//  PostTestAssignmentTests
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import XCTest
@testable import FeedTestAssignment

class PostTestAssignmentTests: XCTestCase {

    var network: NetworkManager!
    
    override func setUp() {
        let engine = FakeNetworkEngine()
        network = NetworkManager(engine: engine)
    }

    override func tearDown() {
    }

    func testLogin() {
        let loginRequest = LoginRequestModel(email: "some@mail.com", password: "12345")
        
        let expectation = self.expectation(description: "Login")
        var loginModel: LoginResponseModel?
        network.execute(requestModel: loginRequest,
                        completion: { (model: LoginResponseModel?) in
                            loginModel = model
                            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(loginModel)
    }
    
    func testLoginParse() {
        let testLoginResponse = "{\"token\":\"askjh\"}"
        
        let data = testLoginResponse.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let login = try? decoder.decode(LoginResponseModel.self, from: data)
        
        XCTAssertNotNil(login)
        XCTAssertNotNil(login?.token)
    }
    
    func testFeedParse() {
        
        let testFeedResponse = "[{\"user\":{\"user_name\":\"D3pjxn6l\",\"user_id\":\"yMAerDUG\"},\"content\":\"Some text\",\"post_id\":\"PCgmNuXw\",\"published_at\":\"26-02-2019T16:38:39\"}]"
        
        let data = testFeedResponse.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let feed = try! decoder.decode(ArrayResponse<FeedResponseModel>.self, from: data)
        
        XCTAssertNotNil(feed.array)
        
        let post = feed.array?.first
        
        XCTAssertNotNil(post?.postID)
        XCTAssertNotNil(post?.content)
    }
}

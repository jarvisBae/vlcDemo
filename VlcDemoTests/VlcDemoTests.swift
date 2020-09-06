//
//  VlcDemoTests.swift
//  VlcDemoTests
//
//  Created by JINKI BAE on 2020/09/02.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import XCTest
@testable import VlcDemo

class VlcDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoadFileParseJSON() throws {
        do {
            if let file = Bundle.main.url(forResource: "videos", withExtension: "txt") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let dict = json as? Dictionary<String,AnyObject> {
                    //TODO json parse
                    let videos = dict["videos"]
                    print("data is : \(videos)")
                }
            } else {
                XCTFail()
            }
        } catch {
            XCTFail()
        }
    }

}

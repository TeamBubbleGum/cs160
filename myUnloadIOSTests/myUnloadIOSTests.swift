//
//  myUnloadIOSTests.swift
//  myUnloadIOSTests
//
//  Created by Cagan Sevencan on 4/19/20.
//  Copyright © 2020 Cagan Sevencan. All rights reserved.
//

import XCTest
@testable import myUnloadIOS

class myUnloadIOSTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        //XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testParseJSON(){
        guard let url = URL(string: "http://localhost:3000/item") else { return }
        var fetchItemsRequest = URLRequest(url: url)
        fetchItemsRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        let s = Service()
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "JSON", ofType: "txt"){
            if let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)){
                let result = s.parseJSON(data: data)
                XCTAssertNotNil(result!, "should not be nil")
                XCTAssertGreaterThan(result!.count, 0, "should have values")
            }else{
                XCTFail()
            }
        }else{
            XCTFail()
        }
    }
    func testUnitTest(){
        var x : Int
        x = 1
        XCTAssertTrue(x == 1, "x should equal 1")
    }
    func testFetchItems(){
        let items = ItemViewController()
        items.fetchItems()
        let count = items.items.count
        XCTAssertNotNil(count, "items should not be nil")
    }
    
    func testFetchfromServer(){
        let items = Service()
        
        //items.fetchItems{ (item, error) in
           // XCTAssertNotNil(item, "should not be empty")
        }
        
    
        
    //starting with 'test' notifies Xcode that it is a unit test
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

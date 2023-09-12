//
//  oddvarTests.swift
//  oddvarTests
//
//  Created by Krister Sigvaldsen Moen on 08/09/2023.
//

import XCTest
import OddvarApi
@testable import oddvarFramework

final class oddvarTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetMockedData() throws {
        let exp = expectation(description: "GetMockedData")

        let vm = PickerContainerViewModel(enviroment: .init(apiClient: .demo, oddvarState: OddvarState()))
        var result = [Item]()
        
        let cancellable = vm.$items.sink { value in
            result = value
        }
        
        vm.onAppear()
        
        after(2) {
            XCTAssertEqual(result.count, 98)
            exp.fulfill()
            cancellable.cancel()
        }
        
        waitForExpectations(timeout: 4, handler: nil)

    }

}

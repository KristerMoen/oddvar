//
//  oddvarUITests.swift
//  oddvarUITests
//
//  Created by Krister Sigvaldsen Moen on 10/09/2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import oddvarFramework
import OddvarApi

final class oddvarUITests: XCTestCase {

    let record = false
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
    
        continueAfterFailure = false
        app.launch()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testScrollDownInApp() {
        let scrolls = 5
        var count = 0
        while count < scrolls {
            app.swipeUp()
            count += 1
        }
    }
    
    func testItemCardFavoritedSnapshot() {
        let itemCardView = ItemCardView(
            imageURL: ItemGroup.mock.items?.first?.image?.imageUrl,
            imageScalable: true,
            location: "BirkebeinerLand",
            description: "Stol selges med forbehold om kattehår",
            price: "2999,-",
            isFavorite: .constant(true)
        )
        
        assertSnapshot(matching: itemCardView, as: .image, record: record)
    }
    
    func testItemCardNotFavoritedSnapshot() {
        let itemCardView = ItemCardView(
            imageURL: ItemGroup.mock.items?.first?.image?.imageUrl,
            imageScalable: true,
            location: "BirkebeinerLand",
            description: "Stol selges med forbehold om kattehår",
            price: "2999,-",
            isFavorite: .constant(false)
        )
        
        assertSnapshot(matching: itemCardView, as: .image, record: record)
    }
    
    func testPickerContainerView() {
        let pickerView = PickerContainerView(enviroment: .init(apiClient: .demo, oddvarState: OddvarState()))
        assertSnapshot(matching: pickerView, as: .image, record: record)
    }

}

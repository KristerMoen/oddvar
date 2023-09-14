//
//  oddvarApp.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 08/09/2023.
//

import SwiftUI
import OddvarApi
import oddvarFramework

@main
struct OddvarApp: App {
    var body: some Scene {
        WindowGroup {
            PickerContainerView(
                enviroment: .init(
                    apiClient: .live(baseURL: Constants.baseURL),
                    oddvarState: OddvarState()
                )
            )
        }
    }
}

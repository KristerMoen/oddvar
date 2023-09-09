//
//  oddvarApp.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 08/09/2023.
//

import SwiftUI

@main
struct OddvarApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView(environment: .init(apiClient: .live(baseURL: Constants.baseURL)))
        }
    }
}

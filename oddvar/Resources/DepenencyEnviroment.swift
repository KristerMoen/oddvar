//
//  DepenencyEnviroment.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 08/09/2023.
//

import Foundation
import OddvarApi
/**
 A Swift class representing a dependency environment for the Oddvar application.
 This class provides access to essential dependencies, such as the API client and state management.

 - Parameters:
    - apiClient: An instance of `OddvarApiClient` for interacting with the Oddvar API.
    - store: An instance of `OddvarState` for managing the state of Oddvar items.

 Example Usage:
 ```swift
 PickerContainerView(
    enviroment: .init(
       apiClient: .live(baseURL: Constants.baseURL),
       oddvarState: OddvarState()
    )
 )
 ```
 */

public class DependencyEnviroment: ObservableObject {
    public let apiClient: OddvarApiClient
    public let store: OddvarState
    
    public init(apiClient: OddvarApiClient, oddvarState: OddvarState) {
        self.apiClient = apiClient
        self.store = oddvarState
    }
}


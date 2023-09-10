//
//  DepenencyEnviroment.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 08/09/2023.
//

import Foundation
import OddvarApi

public class DependencyEnviroment: ObservableObject {
    public let apiClient: OddvarApiClient
    public let store: OddvarState
    
    public init(apiClient: OddvarApiClient, oddvarState: OddvarState) {
        self.apiClient = apiClient
        self.store = oddvarState
    }
}


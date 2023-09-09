//
//  DepenencyEnviroment.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 08/09/2023.
//

import Foundation
import OddvarApi

class DependencyEnvironment: ObservableObject {
    let apiClient: OddvarApiClient
    
    init(apiClient: OddvarApiClient) {
        self.apiClient = apiClient
    }
}


//
//  PickerContainerCore.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 10/09/2023.
//

import Foundation
import Combine
import SwiftUI
import OddvarApi

enum Page: Equatable {
    case nonFiltered
    case filtered
}

@MainActor
public class PickerContainerViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var selectedPage: Page = .nonFiltered
    
    var enviroment: DependencyEnviroment
    init(enviroment: DependencyEnviroment) {
        self.enviroment = enviroment
    }
    
    public func onAppear() {
        Task {
            do {
                let storedItems = try await enviroment.store.load()
                let adItems = try await enviroment.apiClient.getOddvarItems()
                
                DispatchQueue.main.async {
                    if storedItems.isEmpty || adItems.items?.count ?? 0 > storedItems.count {
                        self.items = adItems.items ?? []
                        self.saveItem()
                    } else {
                        self.items = storedItems
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func saveItem(_ item: Item? = nil) {
        Task {
            do {
                let storedItems = try await enviroment.store.load()
                let mutateItems = storedItems
                    .map {
                        if $0.id == item?.id {
                           return $0.update {
                                $0.favorited = item?.favorited ?? false
                            }
                        }
                        return $0
                    }
                
                try await enviroment.store.save(items: mutateItems.isEmpty ? self.items : mutateItems)
               
                
                DispatchQueue.main.async {
                    if self.selectedPage == .filtered {
                        let filtered = mutateItems.filter { $0.favorited == true }
                        self.items = filtered
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func swapItemArray() {
        Task {
            do {
                let storedItems = try await enviroment.store.load()
                
                DispatchQueue.main.async {
                    let filtered = storedItems.filter { $0.favorited == true }
                    self.items = self.selectedPage == .filtered ? filtered : storedItems
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

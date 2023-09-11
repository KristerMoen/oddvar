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

// Enum for switching between all and filtered items in a Picker
enum Page: String, CaseIterable, Equatable, RandomAccessCollection {
    case nonFiltered = "Alle"
    case filtered = "Favoritter"
    
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return Page.allCases.count }

    public subscript(index: Int) -> String {
         return Page.allCases[index].rawValue
     }
}

/**
 This Swift class represents a ViewModel for managing a container of items. It allows loading items from storage and an API, saving items with favorited status, and dynamically updating the displayed items and pages based on user interactions. The ViewModel is designed for SwiftUI and utilizes asynchronous programming to handle data retrieval and updates.
*/

public class PickerContainerViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var selectedPage: Page = .nonFiltered
    @Published var pages: [Page] = [.nonFiltered]
    
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
                    // Checks if it's stored items on disk
                    // TODO: Should check for duplicate items
                    if storedItems.isEmpty || adItems.items?.count ?? 0 > storedItems.count {
                        self.items = adItems.items ?? []
                        self.saveItem()
                    } else {
                        self.items = storedItems
                    }
                    let filtered = self.items.filter { $0.favorited == true }
                    self.pages = filtered.isEmpty ? [.nonFiltered] : [.nonFiltered, .filtered]
                }
            }
            catch {
                // TODO: Add alert
                print(error.localizedDescription)
            }
        }
    }
    
    /**
     Saves an item with favorited status to storage and updates the favorited status of an existing item.

     - Parameters:
        - item: The `Item` to be updated and saved with favorited status. If nil, this function updates existing items.
     */
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
                    let filtered = mutateItems.filter { $0.favorited == true }
                    
                    // Should only be available when on Favorite page
                    if self.selectedPage == .filtered {
                        self.items = filtered
                        self.selectedPage = filtered.isEmpty ? .nonFiltered : self.selectedPage
                    }
                    self.pages = filtered.isEmpty ? [.nonFiltered] : [.nonFiltered, .filtered]
                }
            }
            catch {
                // TODO: Add alert
                print(error.localizedDescription)
            }
        }
    }
    
    /**
     Updates the ViewModel's items based on the selected page, either displaying all items or only favorited ones.
     This function loads items from storage and updates the ViewModel's `items` property accordingly, based on the selected page.

     - Note: The `selectedPage` property determines whether to display all items or only favorited items.
     */
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
                // TODO: Add alert
                print(error.localizedDescription)
            }
        }
    }
}

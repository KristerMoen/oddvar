//
//  ItemListView.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 08/09/2023.
//

import SwiftUI
import OddvarApi

class ItemListViewModel: ObservableObject {
    
    let environment: DependencyEnvironment
    init(environment: DependencyEnvironment) {
        self.environment = environment
    }
    
    @Published var items: [Item] = [Item]()
    
    func onAppear() {
        Task {
            
            do {
                let adItems = try await environment.apiClient.getOddvarItems()
            
                DispatchQueue.main.async {
                    self.items = adItems.items ?? []
                }
            }
            catch {
                print(error)
            }
        }
        
    }
    
}

struct WelcomeView: View {
    
    @StateObject var itemListViewModel: ItemListViewModel
    init(environment: DependencyEnvironment) {
        _itemListViewModel = StateObject(wrappedValue: ItemListViewModel(environment: environment))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(itemListViewModel.items, id: \.id) { item in
                    ItemCardView(
                        imageURL: item.image?.imageUrl,
                        imageScalable: item.image?.scalable ?? false,
                        location: item.location,
                        description: item.description,
                        price: item.price?.prettyNOKFormat ?? "Gis bort",
                        isFavorite: true
                    )
                    
                    .background(.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding()
                }
            }
            .onAppear {
                itemListViewModel.onAppear()
            }
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(environment: .init(apiClient: .demo))
    }
}

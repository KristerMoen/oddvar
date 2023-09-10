//
//  ItemListView.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 08/09/2023.
//

import SwiftUI
import OddvarApi
import Combine

public struct ItemListView: View {
    @Binding var items: [Item]
    var saveAction: (Item) -> Void

    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($items, id: \.id) { $item in
                    ItemCardView(
                        imageURL: item.image?.imageUrl,
                        imageScalable: item.image?.scalable ?? false,
                        location: item.location,
                        description: item.descriptionTitle,
                        price: item.price?.prettyNOKFormat ?? "Gis bort",
                        isFavorite: $item.favorited
                    )
                    .background(.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding()
                    .onChange(of: item.favorited) { _ in
                        saveAction(item)
                    }
                }
              
                
            }
            
        }
    }
}

//struct ItemListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemListView(items: ItemGroup.mock.items ?? [], saveAction: {
//
//        })
//    }
//}


public struct LolListView: View {
    public var body: some View {
        Text("LOL")
    }
}

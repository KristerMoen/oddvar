//
//  ItemListView.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 08/09/2023.
//

import SwiftUI
import OddvarApi
import Combine

/**
 A SwiftUI view responsible for displaying a list of items.

 - Parameters:
    - items: A binding to an array of `Item` objects to display.
    - isAllowedAniamtion: A flag to determine if item removal animations are allowed.
    - saveAction: A closure that is called to save changes to an item.
 */
public struct ItemListView: View {
    @Binding var items: [Item]
    var isAllowedAniamtion: Bool
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
                    .transition(.opacity)
                    .background(Color("backgroundBeige"))
                    .cornerRadius(8)
                    .padding()
                    .onChange(of: item.favorited) { isFavorite in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            saveAction(item)
                            if !isFavorite && isAllowedAniamtion {
                                items.removeAll { $0 == item }
                            }
                        }
                    }
                }
            }
            
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(items: .constant(ItemGroup.mock.items ?? []), isAllowedAniamtion: true, saveAction: { item in
            print("\(item.id) saved")
        })
    }
}

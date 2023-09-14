//
//  ItemCardView.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 09/09/2023.
//

import Foundation
import SwiftUI
import OddvarApi
import CachedAsyncImage

/**
 A SwiftUI view for displaying an item card with details.

 - Parameters:
    - imageURL: The URL for the item's image.
    - imageScalable: A boolean indicating whether the image can be scaled.
    - location: The location associated with the item.
    - description: The description of the item.
    - price: The price of the item.
    - isFavorite: A binding to the item's favorite status.

 - Note: This view allows users to double-tap the card to toggle the favorite status with animation or tapping the overlay image icon

 Example Usage:
 ```swift
 ItemCardView(
     imageURL: "www.finn.pics.com",
     imageScalable: true,
     location: "Oslo",
     description: "Awesome sause",
     price: "2999",
     isFavorite: $item.favorited
 )
 */

public struct ItemCardView: View {
    var imageURL: URL?
    var imageScalable: Bool
    var location: String?
    var description: String?
    var price: String
    @Binding var isFavorite: Bool
    
    public var body: some View {
        VStack {
            CachedAsyncImage(url: imageURL)
                .aspectRatio(contentMode: .fit)
                .frame(width: 350, height: 400)
            
                .overlay(alignment: .topTrailing) {
                    TextImageOverlay(text: price, isFavorite: $isFavorite)
                }
                .overlay(alignment: .bottomTrailing) {
                    TextImageOverlay(image: "heart", selectedImage: "heart.fill", isFavorite: $isFavorite)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .onTapGesture(count: 2) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isFavorite.toggle()
                    }
                }
            
            if let location {
                HStack {
                    Text(location)
                    Spacer()
                }
                .padding()
            }
            HStack {
                Text(description?.firstUppercased ?? "Info kommer")
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .padding(.bottom, 10)
                Spacer()
            }
            .padding([.leading, .trailing])
            
        }
        .padding()
    }
}


struct ItemCardView_Previews: PreviewProvider {
    @State static var value = true
    @State static var value2 = false
    static var previews: some View {
        List{
            ItemCardView(
                imageURL: ItemGroup.mock.items?.first?.image?.imageUrl,
                imageScalable: true,
                location: "BirkebeinerLand",
                description: "Stol selges med forbehold om kattehår",
                price: "2999,-",
                isFavorite: $value
            )
            ItemCardView(
                imageURL: ItemGroup.mock.items?.last?.image?.imageUrl,
                imageScalable: true,
                location: "Oslo",
                description: "Stol selges med forbehold om kattehår",
                price: "455,-",
                isFavorite: $value2
            )
        }
    }
}

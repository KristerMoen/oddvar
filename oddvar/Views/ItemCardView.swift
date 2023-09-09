//
//  ItemCardView.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 09/09/2023.
//

import Foundation
import SwiftUI
import OddvarApi

extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }
}

struct ItemCardView: View {
    var imageURL: URL?
    var imageScalable: Bool
    var location: String?
    var description: String?
    var price: String
    @State var isFavorite: Bool
    
    var body: some View {
        VStack {
            AsyncImage(url: imageURL)
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
            .overlay(alignment: .topTrailing) {
                Text(price)
                    .padding()
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .background(.white.opacity(0.75),
                                in: RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    .padding()
                
            }
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .scaleEffect(isFavorite ? 1.1 : 1)
                    .padding(10)
                    .foregroundColor(isFavorite ? .pink : .mint)
                    .background(.white.opacity(0.75),
                                in: RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    .padding()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            isFavorite.toggle()
                        }
                      
                    }
                
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
                Spacer()
            }
            .padding([.leading, .trailing])
            
        }
        .padding()
    }
}


struct ItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        ItemCardView(
            imageURL: ItemGroup.mock.items?.first?.image?.imageUrl,
            imageScalable: true,
            location: "BirkebeinerLand",
            description: "Stol selges med forbehold om kattehår",
            price: "2999,-",
            isFavorite: true
        )
    }
}

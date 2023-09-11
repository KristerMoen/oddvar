//
//  TextImageOverlay.swift
//  oddvarFramework
//
//  Created by Krister Sigvaldsen Moen on 11/09/2023.
//

import Foundation
import SwiftUI

public struct TextImageOverlay: View {
    var text: String?
    var image: String?
    var selectedImage: String?
    @Binding var isFavorite: Bool
    
    public var body: some View {
        if let text {
            Text(text)
                .padding()
                .font(.system(size: 25, weight: .bold, design: .default))
                .foregroundColor(.white)
                .background(Color("oddvarBlue").opacity(0.75),
                            in: RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .padding()
                .padding([.top, .bottom], 25)
        } else if let image, let selectedImage {
            Image(systemName: isFavorite ? selectedImage : image)
                .resizable()
                .frame(width: 45, height: 40)
                .scaleEffect(isFavorite ? 1.1 : 1)
                .padding(10)
                .foregroundColor(isFavorite ? .pink : .white)
                .background(Color("oddvarBlue").opacity(0.75),
                            in: RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        self.isFavorite.toggle()
                    }
                }
                .padding()
                .padding([.top, .bottom], 25)
        }
    }
}


struct TextImageOverlay_Previews: PreviewProvider {
    @State static var value = false
    
    static var previews: some View {
        VStack {
            TextImageOverlay(text: "299.0", isFavorite: $value)
                .frame(width: 200, height: 200)
            
            TextImageOverlay(image: "heart", selectedImage: "heart.fill", isFavorite: $value)
                .frame(width: 200, height: 200)
        }
    }
}

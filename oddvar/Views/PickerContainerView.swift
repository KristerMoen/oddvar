//
//  PickerContainerView.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 10/09/2023.
//

import SwiftUI
import OddvarApi
import Combine

public struct PickerContainerView: View {
    @StateObject var pickerContainerViewModel: PickerContainerViewModel
    public init(enviroment: DependencyEnviroment) {
        _pickerContainerViewModel = StateObject(wrappedValue: PickerContainerViewModel(enviroment: enviroment))
    }
    
    @ObservedObject var manager = MotionManager()
    
    public var body: some View {
        VStack {
            Picker("", selection: $pickerContainerViewModel.selectedPage) {
                Text("All").tag(Page.nonFiltered)
                Text("Favorited").tag(Page.filtered)
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: pickerContainerViewModel.selectedPage) { newValue in
                pickerContainerViewModel.swapItemArray()
            }
            
            ItemListView(items: $pickerContainerViewModel.items) { item in
                pickerContainerViewModel.saveItem(item)
            }
            .onAppear {
                pickerContainerViewModel.onAppear()
            }
        }
    }
}



struct PickerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerContainerView(enviroment: .init(apiClient: .demoWithManyFavorites, oddvarState: OddvarState()))
    }
}

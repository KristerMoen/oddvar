//
//  PickerContainerView.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 10/09/2023.
//

import SwiftUI
import OddvarApi
import Combine

/**
 A SwiftUI view that displays a picker for selecting different pages and a list of items.

 - Parameters:
    - pickerContainerViewModel: A StateObject that manages the view's data and logic.
    - enviroment: A dependency environment used to initialize the `pickerContainerViewModel`.
 */
public struct PickerContainerView: View {
    @StateObject var pickerContainerViewModel: PickerContainerViewModel
    public init(enviroment: DependencyEnviroment) {
        _pickerContainerViewModel = StateObject(wrappedValue: PickerContainerViewModel(enviroment: enviroment))
    }
    
    public var body: some View {
        VStack {
            Picker("", selection: $pickerContainerViewModel.selectedPage) {
                ForEach($pickerContainerViewModel.pages, id: \.self) { page in
                    Text(page.wrappedValue.rawValue)
                }
            }
            .background(Color("lightBeige"))
            .pickerStyle(.segmented)
            .padding([.leading, .trailing])
            .onChange(of: pickerContainerViewModel.selectedPage) { newValue in
                pickerContainerViewModel.swapItemArray()
            }
            
            ItemListView(items: $pickerContainerViewModel.items, isAllowedAniamtion: pickerContainerViewModel.selectedPage == .filtered) { item in
                pickerContainerViewModel.saveItem(item)
            }
            .onAppear {
                pickerContainerViewModel.onAppear()
            }
            .ignoresSafeArea()
            
        }
        .background(Color("lightBeige"))
        .safeAreaInset(edge: .top) {
            HStack{
                Spacer()
                Button("Tøm lagrede elementer") {
                    pickerContainerViewModel.deleteStorage()
                }
                .padding([.trailing])
                .buttonStyle(.bordered)
                .font(.system(size: 8,weight: .medium))
                .foregroundColor(.red)
                
            }
        }
        .alert(
            "Noe gikk galt!",
            isPresented: $pickerContainerViewModel.error.isNotNil(),
            presenting: pickerContainerViewModel.error,
            actions: { _ in },
            message: { error in
                Text(error)
            }
        )
        .overlay {
            if pickerContainerViewModel.isLoading {
                ProgressView()
            }
        }
    }
}

/**
 This allows you to preview `PickerContainerView` with sample data and dependencies.
 - Returns: A preview of `PickerContainerView` with a predefined environment.
 - Note: The `.init(apiClient: .demoWithManyFavorites)` is a mocked client set in `OddvarApi`, check them out there.
 */
struct PickerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerContainerView(enviroment: .init(apiClient: .demoWithManyFavorites, oddvarState: OddvarState()))
    }
}

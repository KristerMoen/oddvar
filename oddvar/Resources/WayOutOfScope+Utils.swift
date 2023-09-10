//
//  WayOutOfScope+Utils.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 10/09/2023.
//

import Foundation
import CoreMotion
import SwiftUI
struct ViewMotionModifier: ViewModifier {

    @ObservedObject var manager: MotionManager
    var magnitude: Double
    
    func body(content: Content) -> some View {
        content
            .offset(
                x: CGFloat(manager.roll * magnitude),
                y: CGFloat(manager.pitch * magnitude)
            )
    }
}

class MotionManager: ObservableObject {
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    
    private var manager: CMMotionManager

    init() {
        self.manager = CMMotionManager()
        self.manager.deviceMotionUpdateInterval = 1/60
        self.manager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            if let error {
                print(error)
            }

            if let motionData = motionData {
                self.pitch = motionData.attitude.pitch
                self.roll = motionData.attitude.roll
            }
        }

    }
}

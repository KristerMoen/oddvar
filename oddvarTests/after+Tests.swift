//
//  after+Tests.swift
//  oddvarTests
//
//  Created by Krister Sigvaldsen Moen on 11/09/2023.
//

import Foundation

public func after(_ duration: Double, closure: @escaping () -> Void) {
    let delayTime = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)

    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        closure()
    }
}

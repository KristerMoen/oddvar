//
//  OddvarState.swift
//  oddvar
//
//  Created by Krister Sigvaldsen Moen on 10/09/2023.
//

import Foundation
import SwiftUI
import OddvarApi

/**
 A Swift class responsible for managing the state of oddvar `[Item] , including loading and saving items to and from the device's storage.
 This class is designed as an ObservableObject, making it suitable for SwiftUI-based user interfaces.

 - Important: Ensure that this class is used within an environment that supports asynchronous programming.
*/

public class OddvarState: ObservableObject {
    
    public init() { }
    
    public static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("items.data")
    }
    
    public func load() async throws -> [Item] {
        let task = Task<[Item], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let items = try JSONDecoder().decode([Item].self, from: data)
            return items
        }
        let items = try await task.value
        
        return items
    }
    
    public func save(items: [Item]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(items)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    public func deleteAll() async throws {
        let task = Task {
            let outfile = try Self.fileURL()
            try FileManager.default.removeItem(at: outfile)
        }
        _ = try await task.value
    }
}

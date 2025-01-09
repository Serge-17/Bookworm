//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Serge Eliseev on 14.10.2024.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}

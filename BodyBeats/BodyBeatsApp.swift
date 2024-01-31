//
//  BodyBeatsApp.swift
//  BodyBeats
//
//  Created by Thaaranya Subramani on 31/01/24.
//

import SwiftUI

@main
struct BodyBeatsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

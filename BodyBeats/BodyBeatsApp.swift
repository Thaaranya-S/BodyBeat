//
//  BodyBeatsApp.swift
//  BodyBeats
//
//  Created by Thaaranya Subramani on 31/01/24.
//

import SwiftUI

@main
struct BodyBeatsApp: App {
    @StateObject var manager = HealthManager()
    var body: some Scene {
        WindowGroup {
            StoryboardInitialViewController()
                .environmentObject(manager)
//            ActiveTabView()
//                .environmentObject(manager)
        }
    }
}

struct StoryboardInitialViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "LoginViewController", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        return initialViewController!
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update if needed
    }
}

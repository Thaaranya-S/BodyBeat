//
//  PopupMessage.swift
//  BodyBeats
//
//  Created by Thaaranya Subramani on 06/02/24.
//

import SwiftUI

struct ShowMessage: View {
    
    var dismissAction: () -> Void

    var body: some View {
        VStack {
            Text("Custom Popup")
                .font(.title)
                .foregroundColor(.white)
                .padding()

            Text("This is a custom popup message.")
                .foregroundColor(.white)
                .padding()

            Button("OK") {
                dismissAction()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(width: 300, height: 200)
        .background(Color.gray)
        .cornerRadius(16)
    }
}

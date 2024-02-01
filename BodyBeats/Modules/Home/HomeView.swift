//
//  HomeView.swift
//  BodyBeats
//
//  Created by Thaaranya Subramani on 31/01/24.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var userName: String
    @EnvironmentObject var manager: HealthManager
    @State private var welcomeArray = ["Hi there", "your Health Metrics"]
    @State private var currentIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(welcomeArray[currentIndex])
                    .font(.title)
                    .padding()
                    .foregroundColor(.secondary)
                    .onAppear {
                        startWelcomeTimer()
                    }
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                    ForEach(manager.activites.sorted(by: { $0.value.id < $1.value.id}), id: \.key) { item in
                        ActivityCard(activity: item.value)
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
    
    func startWelcomeTimer() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { Timer_ in
            withAnimation {
                currentIndex = (currentIndex + 1) % welcomeArray.count
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userName: .constant("Thaara"))
            .environmentObject(HealthManager())
    }
}

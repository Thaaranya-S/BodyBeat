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
    @State private var showGrid = false
    @State private var animationSpeed: CGFloat = 0.5
    @State private var isShowingPopup = false
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(welcomeArray[currentIndex])
                        .font(.title)
                        .padding()
                        .foregroundColor(.green)
                        .onAppear {
                            startWelcomeTimer()
                        }
                    HStack {
                        LottieView(url: Bundle.main.url(forResource: "Run", withExtension: "lottie")!, speed: animationSpeed)
                            .frame(width: 300, height: 300)
                    }
                    
                    if showGrid {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 1)) {
                            ForEach(manager.activites.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                                ActivityCard(activity: item.value)
                            }
                        }
                        .padding(.horizontal)
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity)) // Combine move and opacity transitions
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .onAppear {
                withAnimation(.easeInOut) {
                    showGrid = true
                }
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

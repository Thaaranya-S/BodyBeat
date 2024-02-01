//
//  ActiveTabView.swift
//  BodyBeats
//
//  Created by Thaaranya Subramani on 31/01/24.
//

import SwiftUI

struct ActiveTabView: View {
    
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(userName: .constant("Thaara"))
                .environmentObject(manager)
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                }
            
            ChartView()
                .environmentObject(manager)
                .tag("Charts")
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                }
        }
    }
}

struct ActiveTabView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTabView()
            .environmentObject(HealthManager())
    }
}

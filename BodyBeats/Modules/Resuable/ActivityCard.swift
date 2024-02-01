//
//  ActivityCard.swift
//  BodyBeats
//
//  Created by Thaaranya Subramani on 31/01/24.
//

import SwiftUI

struct Activity {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let tintColor: Color
    let amount: String
}

struct ActivityCard: View {
    
    @State var activity: Activity
    
    var body: some View {
        
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(activity.title)
                            .font(.system(size: 16))
                        
                        Text(activity.subtitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    Image(systemName: activity.image)
                        .foregroundColor(activity.tintColor)
                }
                .padding()
                
                Text(activity.amount)
                    .font(.system(size: 24))
                    .minimumScaleFactor(0.6)
                    .bold()
                    .padding(.bottom)
            }
            .padding()
            .cornerRadius(12)
        }
    }
}

struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCard(activity: Activity(id: 0, title: "Daily Steps", subtitle: "Goals: 10,000", image: "figure.walk", tintColor: .green, amount: "6543"))
    }
}

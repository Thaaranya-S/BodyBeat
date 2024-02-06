//
//  ChartView.swift
//  BodyBeats
//
//  Created by Thaaranya Subramani on 01/02/24.
//

import SwiftUI
import Charts

struct DailyStepView: Identifiable {
    let id = UUID()
    let date: Date
    let stepCount: Double
}

enum ChartOption {
    case oneWeek
    case oneMonth
    case threeMonth
    case yearToDate
    case oneYear
}

struct ChartView: View {
    @EnvironmentObject var manager: HealthManager
    @State var chartType = [DailyStepView]()
    @State var selectedChart: ChartOption = .oneMonth
    var body: some View {
        VStack(spacing: 12) {
            Text("Weekly Step Count")
                .font(.system(size: 20))
                .bold()
                .padding()
                .foregroundColor(.green)
            
            Chart {
                ForEach(chartType) { daily in
                    BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                }
            }
            .foregroundColor(.green)
            .frame(height: 350)
            .padding(.horizontal)
            
            HStack {
                Button("1Y") {
                    withAnimation {
                        chartType = manager.oneWeekChartDate
                        selectedChart = .oneWeek
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .oneWeek ? .white : .green)
                .background(selectedChart == .oneWeek ? .green : .clear)
                .cornerRadius(10)
                
                Button("3M") {
                    withAnimation {
                        chartType = manager.oneMonthChartDate
                        selectedChart = .oneMonth
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .oneMonth ? .white : .green)
                .background(selectedChart == .oneMonth ? .green : .clear)
                .cornerRadius(10)
                
                Button("1M") {
                    withAnimation {
                        chartType = manager.oneMonthChartDate
                        selectedChart = .threeMonth
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .threeMonth ? .white : .green)
                .background(selectedChart == .threeMonth ? .green : .clear)
                .cornerRadius(10)

            }
            .padding(.top)
        }
        .onAppear {
            chartType = manager.oneWeekChartDate
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}

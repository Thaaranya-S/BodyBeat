//
//  HealthManager.swift
//  BodyBeats
//
//  Created by Thaaranya Subramani on 31/01/24.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
    static var starteOFWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2
        
        return calendar.date(from: components)!
    }
    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let oneMonth = calendar.date(byAdding: .month,value: -1, to: Date())
        return calendar.startOfDay(for: oneMonth!)
    }
}

extension Double {
    func formattedString() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    @Published var activites: [String : Activity] = [:]
    @Published var oneMonthChartDate = [DailyStepView]()
    
    @Published var mockActivies: [String : Activity] = [
        "TodaySteps" : Activity(id: 0, title: "Today steps", subtitle: "10,000", image: "figure.walk", tintColor: .green, amount: "1000"),
        "TodayCalories" : Activity(id: 1, title: "Today Calories", subtitle: "Goal 900", image: "flame", tintColor: .red, amount: "50")
    ]
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKQuantityType.workoutType()
        let helathTypes: Set = [steps, calories, workout]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: helathTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchCurrentWeekWorkoutStats()
                fetchOneMonthStepData()
            } catch {
                print("error fetching health data")
            }
        }
    }
    
    func fetchDailySteps(startDate: Date, completion: @escaping([DailyStepView]) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day:1)
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: interval)
        
        query.initialResultsHandler = { query, result, error in
            guard let result = result else {
                completion([])
                return
            }
            
            var dailySteps = [DailyStepView]()
            
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                dailySteps.append(DailyStepView(date: statistics.startDate, stepCount: statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.00))
            }
            completion(dailySteps)
        }
        healthStore.execute(query)
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fecthed")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Today steps", subtitle: "10,000", image: "figure.walk", tintColor: .green, amount: stepCount.formattedString() ?? "")
            DispatchQueue.main.sync {
                self.activites["todaySteps"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    func fetchTodayCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fecthed")
                return
            }
            
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Today Calories", subtitle: "Goal 900", image: "flame", tintColor: .red, amount:  caloriesBurned.formattedString() ?? "")
            
            DispatchQueue.main.sync {
                self.activites["todayCalories"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    func fetchCurrentWeekWorkoutStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .starteOFWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .traditionalStrengthTraining)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("error fetching week Strength data")
                return
            }
            var runningcount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            
            for workout in workouts {
                if workout.workoutActivityType == .running {
                    let duration = Int(workout.duration)/60
                    runningcount += duration
                }
                else if workout.workoutActivityType == .traditionalStrengthTraining {
                    let duration = Int(workout.duration)/60
                    strengthCount += duration
                }
                else if workout.workoutActivityType == .soccer {
                    let duration = Int(workout.duration)/60
                    soccerCount += duration
                }
                else if workout.workoutActivityType == .baseball {
                    let duration = Int(workout.duration)/60
                    basketballCount += duration
                }
            }
            
            let runningActivity = Activity(id: 2, title: "Running", subtitle: "This week", image: "figure.run", tintColor: .green, amount:  "\(runningcount) minutes")
            
            let strengthActivity = Activity(id: 3, title: "Weight Lifting", subtitle: "This week", image: "dumbbell", tintColor: .cyan, amount:  "\(strengthCount) minutes")
            
            let soccerActivity = Activity(id: 4, title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .blue, amount:  "\(soccerCount) minutes")
            
            let basketBallActivity = Activity(id: 5, title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .orange, amount:  "\(basketballCount) minutes")
            
            let stairActivity = Activity(id: 5, title: "Stair Stepper", subtitle: "This week", image: "figure.stair.stepper", tintColor: .orange, amount:  "\(basketballCount) minutes")
            
            let kickboxActivity = Activity(id: 5, title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .orange, amount:  "\(basketballCount) minutes")
            
            DispatchQueue.main.sync {
                self.activites["weekRunning"] = runningActivity
                self.activites["weekStenght"] = strengthActivity
                self.activites["weekSoccer"] = soccerActivity
                self.activites["weekBasketball"] = basketBallActivity
                self.activites["weekStair"] = stairActivity
                self.activites["weekKickbox"] = kickboxActivity
            }
        }
        healthStore.execute(query)
    }
}

extension HealthManager {
    func fetchOneMonthStepData() {
        fetchDailySteps(startDate: .oneMonthAgo) { dailySteps in
            DispatchQueue.main.async {
                self.oneMonthChartDate = dailySteps
            }
        }
    }
}

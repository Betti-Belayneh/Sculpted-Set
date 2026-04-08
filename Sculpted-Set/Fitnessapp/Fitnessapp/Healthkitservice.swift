//
//  Healthkitservice.swift
//  Fitnessapp
//
//  Created by Betti 
//

import Foundation
import HealthKit

class HealthKitService: ObservableObject {
    let store = HKHealthStore()

    @Published var todaySteps: Int = 0
    @Published var todayCalories: Double = 0
    @Published var todayActiveMinutes: Double = 0
    @Published var todayWaterLiters: Double = 0
    @Published var weeklyWorkouts: [HKWorkout] = []
    @Published var isAuthorized = false
    @Published var errorMessage: String? = nil

    // All types we want to read
    let readTypes: Set<HKObjectType> = [
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
        HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
        HKObjectType.workoutType()
    ]

    // Types we want to write
    let writeTypes: Set<HKSampleType> = [
        HKObjectType.workoutType(),
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
    ]

    // MARK: - Request Permission
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            DispatchQueue.main.async {
                self.errorMessage = "Health data is not available on this device."
            }
            completion(false)
            return
        }

        store.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
                completion(success)
            }
        }
    }

    // MARK: - Fetch All Today's Data
    func fetchAllTodayData() {
        fetchTodaySteps()
        fetchTodayCalories()
        fetchTodayActiveMinutes()
        fetchTodayWater()
        fetchWeeklyWorkouts()
    }

    // MARK: - Steps
    func fetchTodaySteps() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())

        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                self.todaySteps = Int(result?.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        }
        store.execute(query)
    }

    // MARK: - Calories
    func fetchTodayCalories() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())

        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                self.todayCalories = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            }
        }
        store.execute(query)
    }

    // MARK: - Active Minutes
    func fetchTodayActiveMinutes() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())

        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                self.todayActiveMinutes = result?.sumQuantity()?.doubleValue(for: .minute()) ?? 0
            }
        }
        store.execute(query)
    }

    // MARK: - Water
    func fetchTodayWater() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())

        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                self.todayWaterLiters = result?.sumQuantity()?.doubleValue(for: .liter()) ?? 0
            }
        }
        store.execute(query)
    }

    // MARK: - Weekly Workouts
    func fetchWeeklyWorkouts() {
        let startOfWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startOfWeek, end: Date())
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: 20, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            DispatchQueue.main.async {
                self.weeklyWorkouts = samples as? [HKWorkout] ?? []
            }
        }
        store.execute(query)
    }

    // MARK: - Save Workout to Apple Health
    func saveWorkout(startDate: Date, durationMins: Int, caloriesBurned: Double, completion: @escaping (Bool) -> Void) {
        let endDate = startDate.addingTimeInterval(TimeInterval(durationMins * 60))

        let workout = HKWorkout(
            activityType: .traditionalStrengthTraining,
            start: startDate,
            end: endDate,
            duration: TimeInterval(durationMins * 60),
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: caloriesBurned),
            totalDistance: nil,
            metadata: nil
        )

        store.save(workout) { success, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
                completion(success)
            }
        }
    }

    // MARK: - Helpers
    var stepGoalProgress: Double {
        min(Double(todaySteps) / 10000.0, 1.0)
    }

    var calorieGoalProgress: Double {
        min(todayCalories / 500.0, 1.0)
    }

    var activeMinutesGoalProgress: Double {
        min(todayActiveMinutes / 30.0, 1.0)
    }

    var waterGoalProgress: Double {
        min(todayWaterLiters / 2.0, 1.0)
    }

    func workoutName(_ workout: HKWorkout) -> String {
        switch workout.workoutActivityType {
        case .traditionalStrengthTraining: return "Strength Training"
        case .running: return "Running"
        case .walking: return "Walking"
        case .cycling: return "Cycling"
        case .yoga: return "Yoga"
        case .hiking: return "Hiking"
        case .swimming: return "Swimming"
        case .highIntensityIntervalTraining: return "HIIT"
        case .functionalStrengthTraining: return "Functional Training"
        case .dance: return "Dance"
        default: return "Workout"
        }
    }

    func workoutIcon(_ workout: HKWorkout) -> String {
        switch workout.workoutActivityType {
        case .traditionalStrengthTraining, .functionalStrengthTraining: return "figure.strengthtraining.traditional"
        case .running: return "figure.run"
        case .walking: return "figure.walk"
        case .cycling: return "figure.outdoor.cycle"
        case .yoga: return "figure.yoga"
        case .hiking: return "figure.hiking"
        case .swimming: return "figure.pool.swim"
        case .highIntensityIntervalTraining: return "bolt.fill"
        case .dance: return "figure.dance"
        default: return "heart.fill"
        }
    }
}

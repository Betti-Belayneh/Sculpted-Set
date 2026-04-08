//
//  Healthview.swift
//  Fitnessapp
//
//  Created by Betti 
//

import SwiftUI
import HealthKit

struct HealthView: View {
    @EnvironmentObject var healthKit: HealthKitService

    let brown = Color(red: 0.18, green: 0.10, blue: 0.05)
    let accent = Color(red: 0.76, green: 0.49, blue: 0.27)
    let medBrown = Color(red: 0.48, green: 0.25, blue: 0.10)
    let cardBg = Color(red: 0.25, green: 0.14, blue: 0.07)

    var body: some View {
        ZStack {
            brown.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Health")
                                .font(.title).fontWeight(.bold).foregroundColor(accent)
                            Text("Today's Activity")
                                .font(.subheadline).foregroundColor(.white.opacity(0.5))
                        }
                        Spacer()
                        Button {
                            healthKit.fetchAllTodayData()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(accent).font(.title3)
                        }
                    }
                    .padding(.horizontal).padding(.top, 10)

                    if !healthKit.isAuthorized {
                        // Permission request card
                        VStack(spacing: 16) {
                            Image(systemName: "heart.text.square.fill")
                                .font(.system(size: 50))
                                .foregroundColor(accent)

                            Text("Connect Apple Health")
                                .font(.title3).fontWeight(.bold).foregroundColor(.white)

                            Text("Allow Sculpted Set to read your steps, calories, active minutes, and workouts from Apple Health.")
                                .font(.subheadline).foregroundColor(.white.opacity(0.6))
                                .multilineTextAlignment(.center).padding(.horizontal)

                            Button {
                                healthKit.requestAuthorization { granted in
                                    if granted { healthKit.fetchAllTodayData() }
                                }
                            } label: {
                                Text("Connect Health")
                                    .font(.headline).frame(maxWidth: .infinity).frame(height: 54)
                                    .background(medBrown).foregroundColor(.white)
                                    .cornerRadius(14).padding(.horizontal)
                            }
                        }
                        .padding(24)
                        .background(cardBg).cornerRadius(16).padding(.horizontal)
                    } else {
                        // Today's stats grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            healthStatCard(
                                icon: "figure.walk",
                                value: "\(healthKit.todaySteps.formatted())",
                                label: "Steps",
                                goal: "Goal: 10,000",
                                progress: healthKit.stepGoalProgress,
                                color: Color(red: 0.4, green: 0.8, blue: 0.4)
                            )
                            healthStatCard(
                                icon: "flame.fill",
                                value: "\(Int(healthKit.todayCalories))",
                                label: "Calories",
                                goal: "Goal: 500 kcal",
                                progress: healthKit.calorieGoalProgress,
                                color: Color(red: 1.0, green: 0.5, blue: 0.2)
                            )
                            healthStatCard(
                                icon: "clock.fill",
                                value: "\(Int(healthKit.todayActiveMinutes))m",
                                label: "Active Time",
                                goal: "Goal: 30 min",
                                progress: healthKit.activeMinutesGoalProgress,
                                color: Color(red: 0.4, green: 0.6, blue: 1.0)
                            )
                            healthStatCard(
                                icon: "drop.fill",
                                value: String(format: "%.1fL", healthKit.todayWaterLiters),
                                label: "Water",
                                goal: "Goal: 2.0 L",
                                progress: healthKit.waterGoalProgress,
                                color: Color(red: 0.3, green: 0.7, blue: 1.0)
                            )
                        }
                        .padding(.horizontal)

                        // Weekly workouts from Health
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Workouts from Health")
                                .font(.title3).fontWeight(.bold).foregroundColor(.white).padding(.horizontal)

                            if healthKit.weeklyWorkouts.isEmpty {
                                VStack(spacing: 10) {
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.system(size: 36)).foregroundColor(accent.opacity(0.5))
                                    Text("No workouts found in the last 7 days")
                                        .font(.subheadline).foregroundColor(.white.opacity(0.5))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity).padding(30)
                                .background(cardBg).cornerRadius(14).padding(.horizontal)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(healthKit.weeklyWorkouts, id: \.uuid) { workout in
                                        HStack(spacing: 14) {
                                            ZStack {
                                                Circle().fill(medBrown).frame(width: 44, height: 44)
                                                Image(systemName: healthKit.workoutIcon(workout))
                                                    .foregroundColor(accent).font(.system(size: 18))
                                            }
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(healthKit.workoutName(workout))
                                                    .font(.headline).foregroundColor(.white)
                                                Text(workout.startDate, style: .date)
                                                    .font(.caption).foregroundColor(.white.opacity(0.5))
                                            }
                                            Spacer()
                                            VStack(alignment: .trailing, spacing: 4) {
                                                Text("\(Int(workout.duration / 60)) min")
                                                    .font(.subheadline).fontWeight(.semibold).foregroundColor(accent)
                                                if let cal = workout.totalEnergyBurned {
                                                    Text("\(Int(cal.doubleValue(for: .kilocalorie()))) kcal")
                                                        .font(.caption).foregroundColor(.white.opacity(0.5))
                                                }
                                            }
                                        }
                                        .padding(14)
                                        .background(cardBg).cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        if let error = healthKit.errorMessage {
                            Text(error)
                                .font(.caption).foregroundColor(.red.opacity(0.8))
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            if healthKit.isAuthorized {
                healthKit.fetchAllTodayData()
            }
        }
    }

    func healthStatCard(icon: String, value: String, label: String, goal: String, progress: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon).foregroundColor(color).font(.system(size: 18))
                Spacer()
                Text(goal).font(.caption2).foregroundColor(.white.opacity(0.4))
            }

            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text(label)
                .font(.caption).foregroundColor(.white.opacity(0.6))

            // Mini progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().foregroundColor(Color.white.opacity(0.1))
                        .frame(width: geo.size.width, height: 5).cornerRadius(3)
                    Rectangle().foregroundColor(color)
                        .frame(width: geo.size.width * CGFloat(progress), height: 5).cornerRadius(3)
                }
            }
            .frame(height: 5)
        }
        .padding(14)
        .background(cardBg)
        .cornerRadius(14)
    }
}

#Preview {
    HealthView().environmentObject(HealthKitService())
}

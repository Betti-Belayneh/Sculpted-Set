//
//  Workoutprogressview.swift
//  Fitnessapp
//
//  Created by Betti
//

import SwiftUI

struct WorkoutProgressView: View {
    @EnvironmentObject var workoutStore: WorkoutStore

    let brown = Color(red: 0.18, green: 0.10, blue: 0.05)
    let accent = Color(red: 0.76, green: 0.49, blue: 0.27)
    let medBrown = Color(red: 0.48, green: 0.25, blue: 0.10)

    var body: some View {
        ZStack {
            brown.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("Progress")
                            .font(.title).fontWeight(.bold).foregroundColor(accent)
                        Spacer()
                    }
                    .padding(.horizontal).padding(.top, 10)

                    // Stats row
                    HStack(spacing: 12) {
                        statCard(value: "\(workoutStore.totalWorkouts)", label: "Workouts", icon: "dumbbell.fill")
                        statCard(value: "\(workoutStore.totalMinutes)", label: "Minutes", icon: "clock.fill")
                        statCard(value: "\(workoutStore.currentStreak)", label: "Day Streak", icon: "flame.fill")
                    }
                    .padding(.horizontal)

                    // History
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Workout History")
                            .font(.title3).fontWeight(.bold).foregroundColor(.white).padding(.horizontal)

                        if workoutStore.sessions.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 40))
                                    .foregroundColor(accent.opacity(0.5))
                                Text("No workouts yet")
                                    .foregroundColor(.white.opacity(0.5))
                                Text("Complete a workout to see your history here.")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.3))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(30)
                        } else {
                            VStack(spacing: 10) {
                                ForEach(workoutStore.sessions) { session in
                                    sessionCard(session)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }

    func statCard(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(accent)
            Text(value)
                .font(.title2).fontWeight(.bold).foregroundColor(.white)
            Text(label)
                .font(.caption).foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.07))
        .cornerRadius(14)
    }

    func sessionCard(_ session: WorkoutSession) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.bodyPart)
                        .font(.headline).foregroundColor(.white)
                    Text(session.date, style: .date)
                        .font(.caption).foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(session.durationMins) min")
                        .font(.subheadline).fontWeight(.semibold).foregroundColor(accent)
                    Text("\(session.exercises.count) exercises")
                        .font(.caption).foregroundColor(.white.opacity(0.5))
                }
            }

            // Exercise chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(session.exercises.prefix(5), id: \.self) { exercise in
                        Text(exercise)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(8)
                    }
                    if session.exercises.count > 5 {
                        Text("+\(session.exercises.count - 5) more")
                            .font(.caption2).foregroundColor(accent)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.white.opacity(0.08)).cornerRadius(8)
                    }
                }
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.07))
        .cornerRadius(14)
    }
}

#Preview {
    WorkoutProgressView().environmentObject(WorkoutStore())
}

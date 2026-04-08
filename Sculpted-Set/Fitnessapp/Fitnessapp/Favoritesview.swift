//
//  Favoritesview.swift
//  Fitnessapp
//
//  Created by Betti
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @State private var selectedTab = 0

    let brown = Color(red: 0.18, green: 0.10, blue: 0.05)
    let accent = Color(red: 0.76, green: 0.49, blue: 0.27)
    let medBrown = Color(red: 0.48, green: 0.25, blue: 0.10)

    var body: some View {
        ZStack {
            brown.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text("Favorites")
                        .font(.title).fontWeight(.bold).foregroundColor(accent)
                    Spacer()
                }
                .padding(.horizontal).padding(.top, 10).padding(.bottom, 16)

                // Tab switcher
                HStack(spacing: 0) {
                    ForEach(["Exercises", "Routines"], id: \.self) { tab in
                        let index = tab == "Exercises" ? 0 : 1
                        Button {
                            withAnimation { selectedTab = index }
                        } label: {
                            Text(tab)
                                .font(.subheadline).fontWeight(.semibold)
                                .foregroundColor(selectedTab == index ? .white : .white.opacity(0.4))
                                .frame(maxWidth: .infinity).padding(.vertical, 10)
                                .background(selectedTab == index ? medBrown : Color.clear)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(4)
                .background(Color.white.opacity(0.07))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 16)

                ScrollView {
                    if selectedTab == 0 {
                        exercisesTab
                    } else {
                        routinesTab
                    }
                }
            }
        }
    }

    var exercisesTab: some View {
        VStack(spacing: 10) {
            if workoutStore.favoriteExercises.isEmpty {
                emptyState(icon: "heart", message: "No favorite exercises yet",
                           detail: "Tap the heart icon next to exercises in your workout to save them here.")
            } else {
                ForEach(workoutStore.favoriteExercises) { exercise in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.name)
                                .font(.headline).foregroundColor(.white)
                            Text(exercise.bodyPart)
                                .font(.caption).foregroundColor(accent)
                        }
                        Spacer()
                        Button {
                            workoutStore.removeFavoriteExercise(id: exercise.id)
                        } label: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red).font(.system(size: 18))
                        }
                    }
                    .padding(14)
                    .background(Color.white.opacity(0.07))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 30)
    }

    var routinesTab: some View {
        VStack(spacing: 10) {
            if workoutStore.favoriteRoutines.isEmpty {
                emptyState(icon: "bookmark", message: "No saved routines yet",
                           detail: "Save a workout routine from the Workout tab to find it here.")
            } else {
                ForEach(workoutStore.favoriteRoutines) { routine in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(routine.name)
                                    .font(.headline).foregroundColor(.white)
                                Text("\(routine.bodyPart)  •  \(routine.durationMins) min  •  \(routine.exercises.count) exercises")
                                    .font(.caption).foregroundColor(accent)
                            }
                            Spacer()
                            Button {
                                workoutStore.removeFavoriteRoutine(id: routine.id)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red.opacity(0.7)).font(.system(size: 16))
                            }
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(routine.exercises.prefix(6), id: \.self) { exercise in
                                    Text(exercise)
                                        .font(.caption2).foregroundColor(.white.opacity(0.7))
                                        .padding(.horizontal, 8).padding(.vertical, 4)
                                        .background(Color.white.opacity(0.08)).cornerRadius(8)
                                }
                                if routine.exercises.count > 6 {
                                    Text("+\(routine.exercises.count - 6) more")
                                        .font(.caption2).foregroundColor(accent)
                                        .padding(.horizontal, 8).padding(.vertical, 4)
                                        .background(Color.white.opacity(0.08)).cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(14)
                    .background(Color.white.opacity(0.07))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 30)
    }

    func emptyState(icon: String, message: String, detail: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundColor(accent.opacity(0.5))
            Text(message)
                .font(.headline).foregroundColor(.white.opacity(0.7))
            Text(detail)
                .font(.caption).foregroundColor(.white.opacity(0.4))
                .multilineTextAlignment(.center).padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity).padding(50)
    }
}

#Preview {
    FavoritesView().environmentObject(WorkoutStore())
}

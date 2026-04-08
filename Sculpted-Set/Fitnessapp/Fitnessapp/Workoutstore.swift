//
//  Workoutstore.swift
//  Fitnessapp
//
//  Created by Betti
//

import Foundation

struct WorkoutSession: Codable, Identifiable {
    let id: UUID
    let date: Date
    let durationMins: Int
    let bodyPart: String
    let exercises: [String]

    init(date: Date, durationMins: Int, bodyPart: String, exercises: [String]) {
        self.id = UUID()
        self.date = date
        self.durationMins = durationMins
        self.bodyPart = bodyPart
        self.exercises = exercises
    }
}

struct FavoriteExercise: Codable, Identifiable {
    let id: UUID
    let name: String
    let bodyPart: String

    init(name: String, bodyPart: String) {
        self.id = UUID()
        self.name = name
        self.bodyPart = bodyPart
    }
}

struct FavoriteRoutine: Codable, Identifiable {
    let id: UUID
    let name: String
    let bodyPart: String
    let durationMins: Int
    let exercises: [String]

    init(name: String, bodyPart: String, durationMins: Int, exercises: [String]) {
        self.id = UUID()
        self.name = name
        self.bodyPart = bodyPart
        self.durationMins = durationMins
        self.exercises = exercises
    }
}

// MARK: - WorkoutStore

final class WorkoutStore: ObservableObject {
    @Published var sessions: [WorkoutSession] = []
    @Published var favoriteExercises: [FavoriteExercise] = []
    @Published var favoriteRoutines: [FavoriteRoutine] = []

    private let sessionsKey = "workoutSessions"
    private let favExercisesKey = "favoriteExercises"
    private let favRoutinesKey = "favoriteRoutines"

    init() {
        load()
    }

    func saveSession(_ session: WorkoutSession) {
        sessions.insert(session, at: 0)
        persist()
    }

    func addFavoriteExercise(name: String, bodyPart: String) {
        guard !favoriteExercises.contains(where: { $0.name == name }) else { return }
        favoriteExercises.append(FavoriteExercise(name: name, bodyPart: bodyPart))
        persist()
    }

    func removeFavoriteExercise(id: UUID) {
        favoriteExercises.removeAll { $0.id == id }
        persist()
    }

    func isFavoriteExercise(name: String) -> Bool {
        favoriteExercises.contains { $0.name == name }
    }

    func addFavoriteRoutine(name: String, bodyPart: String, durationMins: Int, exercises: [String]) {
        let routine = FavoriteRoutine(name: name, bodyPart: bodyPart, durationMins: durationMins, exercises: exercises)
        favoriteRoutines.append(routine)
        persist()
    }

    func removeFavoriteRoutine(id: UUID) {
        favoriteRoutines.removeAll { $0.id == id }
        persist()
    }

    var totalWorkouts: Int { sessions.count }
    var totalMinutes: Int { sessions.reduce(0) { $0 + $1.durationMins } }

    var currentStreak: Int {
        guard !sessions.isEmpty else { return 0 }
        let calendar = Calendar.current
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())

        for session in sessions {
            let sessionDay = calendar.startOfDay(for: session.date)
            if sessionDay == checkDate {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else if sessionDay < checkDate {
                break
            }
        }
        return streak
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: sessionsKey)
        }
        if let data = try? JSONEncoder().encode(favoriteExercises) {
            UserDefaults.standard.set(data, forKey: favExercisesKey)
        }
        if let data = try? JSONEncoder().encode(favoriteRoutines) {
            UserDefaults.standard.set(data, forKey: favRoutinesKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([WorkoutSession].self, from: data) {
            sessions = decoded
        }
        if let data = UserDefaults.standard.data(forKey: favExercisesKey),
           let decoded = try? JSONDecoder().decode([FavoriteExercise].self, from: data) {
            favoriteExercises = decoded
        }
        if let data = UserDefaults.standard.data(forKey: favRoutinesKey),
           let decoded = try? JSONDecoder().decode([FavoriteRoutine].self, from: data) {
            favoriteRoutines = decoded
        }
    }
}

//
//  TimerService.swift
//  Fitnessapp
//
//  Created by Betti
//

import Foundation
import AVFoundation

class TimerService: ObservableObject {
    @Published var selectedMins = 20
    @Published var timeRemaining: TimeInterval = 1200
    @Published var isTimerRunning = false
    @Published var currentExerciseIndex = 0
    @Published var exerciseList: [(name: String, duration: Int)] = []
    @Published var isLastMin = false
    @Published var selectedBodyPart: String = ""
    @Published var isWorkoutComplete = false

    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?

    let exercisesByBodyPart: [String: [String]] = [
        "Glutes": ["Glute Bridge", "Hip Thrust", "Donkey Kicks", "Fire Hydrants",
                   "Cable Kickbacks", "Sumo Squats", "Bulgarian Split Squat",
                   "Banded Side Steps", "Clamshells", "Single-Leg Glute Bridge",
                   "Frog Pumps", "Dumbbell Hip Thrusts", "Reverse Hyperextensions"],
        "Legs": ["Squats", "Lunges", "Leg Press", "Calf Raises", "Hamstring Curls",
                 "Wall Sit", "Step-Ups", "Romanian Deadlift", "Lying Hamstring Curls",
                 "Walking Lunges", "Reverse Lunges", "Jumping Squats",
                 "Single-Leg Deadlift", "Leg Extensions"],
        "Arms": ["Bicep Curls", "Hammer Curls", "Tricep Dips", "Tricep Pushdowns",
                 "Overhead Tricep Extension", "Concentration Curls", "Preacher Curls",
                 "Skull Crushers", "Zottman Curls", "Diamond Push-Ups",
                 "Close-Grip Bench Press", "Cable Curls", "Rope Pushdowns"],
        "Back": ["Deadlift", "Bent-Over Row", "Lat Pulldown", "Seated Cable Row",
                 "Pull-Ups", "Face Pulls", "Single-Arm Dumbbell Row",
                 "T-Bar Row", "Straight-Arm Pulldown", "Good Mornings",
                 "Superman Hold", "Reverse Flyes", "Rack Pulls"],
        "Core": ["Plank", "Crunches", "Bicycle Crunches", "Leg Raises",
                 "Russian Twists", "Mountain Climbers", "Dead Bug",
                 "Flutter Kicks", "Side Plank", "Hollow Body Hold",
                 "Ab Wheel Rollout", "Cable Crunches", "Hanging Knee Raises"],
        "Full Body": ["Burpees", "Deadlift", "Squats", "Pull-Ups", "Push-Ups",
                      "Kettlebell Swings", "Clean and Press", "Thrusters",
                      "Box Jumps", "Battle Ropes", "Dumbbell Snatch",
                      "Man Makers", "Turkish Get-Up"]
    ]

    private let transitionSounds = ["sound1", "sound2", "sound3", "sound4"]

    func startTimer() {
        isTimerRunning = true
        isWorkoutComplete = false
        updateCurrentExercise()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining == 60 { self.isLastMin = true; self.playMinSound() }
            if self.timeRemaining > 0 {
                let prev = self.currentExerciseIndex
                self.timeRemaining -= 1
                self.updateCurrentExercise()
                if prev != self.currentExerciseIndex { self.playTransitionSound() }
            } else {
                self.stopTimer()
                self.isWorkoutComplete = true
            }
        }
    }

    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        stopTimer()
        isWorkoutComplete = false
        timeRemaining = Double(selectedMins * 60)
        currentExerciseIndex = 0
        isLastMin = false
        if !selectedBodyPart.isEmpty { generateWorkoutList() }
    }

    func timeString(_ time: TimeInterval) -> String {
        let mins = Int(time) / 60
        let secs = Int(time) % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    func updateWorkoutDuration(mins: Int) {
        selectedMins = mins
        timeRemaining = Double(mins * 60)
        if !selectedBodyPart.isEmpty { generateWorkoutList() }
    }

    func selectBodyPart(_ bodyPart: String) {
        selectedBodyPart = bodyPart
        generateWorkoutList()
    }

    func generateWorkoutList() {
        let exercises = exercisesByBodyPart[selectedBodyPart] ?? exercisesByBodyPart["Full Body"]!
        var remainingMins = selectedMins
        var shuffled = exercises.shuffled()
        var generatedList: [(String, Int)] = []

        while remainingMins > 0 {
            if shuffled.isEmpty { shuffled = exercises.shuffled() }
            if remainingMins == 1 {
                generatedList.append((shuffled.removeFirst(), 1))
                remainingMins = 0
            } else {
                let maxDuration = min(6, remainingMins - 1)
                let minDuration = min(2, maxDuration)
                guard minDuration <= maxDuration else {
                    generatedList.append((shuffled.removeFirst(), remainingMins))
                    break
                }
                let duration = Int.random(in: minDuration...maxDuration)
                generatedList.append((shuffled.removeFirst(), duration))
                remainingMins -= duration
            }
        }
        self.exerciseList = generatedList
        self.currentExerciseIndex = 0
    }

    func updateCurrentExercise() {
        let elapsedMins = Int((Double(selectedMins * 60) - timeRemaining) / 60)
        var accumulated = 0
        for (index, exercise) in exerciseList.enumerated() {
            accumulated += exercise.duration
            if elapsedMins < accumulated { currentExerciseIndex = index; break }
        }
    }

    func getCurrentExerciseElapsedTime() -> Double {
        let elapsed = Double(selectedMins * 60) - timeRemaining
        var accumulated = 0
        for i in 0..<currentExerciseIndex { accumulated += exerciseList[i].duration }
        return elapsed - Double(accumulated * 60)
    }

    func getOverallProgress() -> Double {
        let total = Double(selectedMins * 60)
        return (total - timeRemaining) / total
    }

    func playMinSound() { playSound(named: "princess-sound") }
    func playTransitionSound() { playSound(named: transitionSounds[Int.random(in: 0..<transitionSounds.count)]) }

    private func playSound(named name: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            do { audioPlayer = try AVAudioPlayer(contentsOf: url); audioPlayer?.play() }
            catch { print("ERROR: sound failed - \(name)") }
        }
    }
}

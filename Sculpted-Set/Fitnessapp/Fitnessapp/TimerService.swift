//
//  TimerService.swift
//  Fitnessapp
//
//  Created by Miriam on 4/23/25.
//

import Foundation
import AVFoundation
import SwiftUI

class TimerService: ObservableObject {
    // Published variables 
    @Published var selectedMins = 5
    @Published var timeRemaining: TimeInterval = 300
    @Published var isTimerRunning = false
    @Published var currentExerciseIndex = 0
    @Published var exerciseList: [(name: String, duration: Int)] = []
    @Published var isLastMin = false

    // Private variables
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?

    
    private let exercises: [String] = [
        "Squats",
        "Lunges",
        "Leg Press",
        "Calf Raises",
        "Hamstring Curls",
        "Wall Sit",
        "Step-Ups",
        "Donkey Kicks",
        "Glute Bridge",
        "Romanian Deadlift",
        "Deadlift",
        "Lying Hamstring Curls",
        "Walking Lunges",
        "Mountain Climbers",
        "Jumping Squats",
        "Reverse Lunges",
        "Dumbbell Hipthrusts",
        "Burpes",
        "Walking Lunges with Weights",
        "Single-Leg Deadlift",
        "Clamshell",
        "Banded Side-Step",
    ]
    
    private let transitionSounds: [String] = [
        "sound1",
        "sound2",
        "sound3",
        "sound4"
    ]
    
    init() {
        generateWorkoutList()
    }

    // functionality 1: timer
    func startTimer() {
        isTimerRunning = true
        updateCurrentExercise()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining == 60 {
                self.isLastMin = true
                self.playMinSound()
            }
            if self.timeRemaining > 0 {
                let prevIndex = self.currentExerciseIndex
                self.timeRemaining -= 1
                self.updateCurrentExercise()
                
                
                if (prevIndex != self.currentExerciseIndex){
                    self.playTransitionSound()
                }
                
            } else {
                self.stopTimer()
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
        timeRemaining = Double(selectedMins * 60)
        generateWorkoutList()
    }

    func timeString(_ time: TimeInterval) -> String {
        let mins = Int(time) / 60
        let secs = Int(time) % 60
        return String(format: "%02d:%02d", mins, secs)
    }



    // functionality 2: creates workout based on timer 
    func updateWorkoutDuration(mins: Int) {
        selectedMins = mins
        timeRemaining = Double(mins * 60)
        generateWorkoutList()
    }

    private func generateWorkoutList() {
        var remainingMins = selectedMins
        var selectedWorkouts = exercises.shuffled()
        var generatedList: [(String, Int)] = []
    
        while remainingMins > 0 {
            if selectedWorkouts.isEmpty {
                selectedWorkouts = exercises.shuffled()
            }
            
            if remainingMins == 1 {
                let workoutName = selectedWorkouts.removeFirst()
                generatedList.append((workoutName, 1))
                remainingMins = 0
            } else {
                //testing (change back to 2-6)
                let maxDuration = min(1, remainingMins - 1)
                let minDuration = min(1, remainingMins)
                let randomDuration = Int.random(in: minDuration...maxDuration)
                
                let workoutName = selectedWorkouts.removeFirst()
                generatedList.append((workoutName, randomDuration))
                remainingMins -= randomDuration
            }
        }
        
        self.exerciseList = generatedList
    } 

    func updateCurrentExercise() {
        let elapsedSecs = Double(selectedMins * 60) - timeRemaining
        let elapsedMins = Int(elapsedSecs / 60)

        var minsAccumulated = 0
        for (index, exercise) in exerciseList.enumerated() {
            minsAccumulated += exercise.duration
            if elapsedMins < minsAccumulated {
                currentExerciseIndex = index
                break
            }
        }
    }

    func getCurrentExerciseElapsedTime() -> Double {
        let totalSecs = Double(selectedMins * 60)
        let remainingSecs = timeRemaining
        let elapsedSecs = totalSecs - remainingSecs
        
        var minsAccumulated = 0
        for i in 0 ..< currentExerciseIndex {
            minsAccumulated += exerciseList[i].duration
        }
        
        let exerciseStartSecs = Double(minsAccumulated * 60)
        return elapsedSecs - exerciseStartSecs
    }
    
    func getOverallProgress() -> Double {
        let totalSecs = Double(selectedMins * 60)
        let remainingSecs = timeRemaining
        return (totalSecs - remainingSecs) / totalSecs
    }

    // functionality 3: play sound when 1 minute remaining of workout out 
    func playMinSound() {
        if let soundURL = Bundle.main.url(forResource: "princess-sound", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
                print("SUCCESS: Last minute sound played")
            } catch {
                print("ERROR: sound failed to play")
            }
        }
    }
    
   func playTransitionSound() {
       let randomNum = Int.random(in: 0...transitionSounds.count-1)
       let randomSound = transitionSounds[randomNum]
        if let soundURL = Bundle.main.url(forResource: randomSound, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
                print("SUCCESS: Transition sound played")
            } catch {
                print("ERROR: sound failed to play")
            }
        }
    }



}  //end of TimerService()

//
//  TimerView.swift
//  Fitnessapp
// created by Betti
//

import SwiftUI

struct ExerciseInfo {
    let reps: String
    let sets: String
    let tip: String
    let icon: String
}

struct TimerView: View {
    @StateObject private var timerService = TimerService()
    @StateObject private var musicService = MusicService()
    @EnvironmentObject var workoutStore: WorkoutStore
    @State private var showSetup = true
    @State private var showSaveRoutine = false
    @State private var showMusicPicker = false
    @State private var routineName = ""
    @State private var showCompletionSheet = false
    @State private var isHydrationBreak = false
    @State private var hydrationTimeLeft = 30
    @State private var hydrationTimer: Timer? = nil

    let bodyParts = ["Glutes", "Legs", "Arms", "Back", "Core", "Full Body"]
    let minutes = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]

    let brown = Color(red: 0.18, green: 0.10, blue: 0.05)
    let accent = Color(red: 0.76, green: 0.49, blue: 0.27)
    let medBrown = Color(red: 0.48, green: 0.25, blue: 0.10)
    let cardBg = Color(red: 0.25, green: 0.14, blue: 0.07)

    let exerciseInfoMap: [String: ExerciseInfo] = [
        "Glute Bridge":         ExerciseInfo(reps: "15 reps", sets: "3 sets", tip: "Squeeze glutes at the top", icon: "figure.strengthtraining.functional"),
        "Hip Thrust":           ExerciseInfo(reps: "12 reps", sets: "4 sets", tip: "Drive through your heels", icon: "figure.strengthtraining.functional"),
        "Donkey Kicks":         ExerciseInfo(reps: "15 each", sets: "3 sets", tip: "Keep hips square to floor", icon: "figure.strengthtraining.functional"),
        "Fire Hydrants":        ExerciseInfo(reps: "15 each", sets: "3 sets", tip: "Controlled slow movement", icon: "figure.strengthtraining.functional"),
        "Cable Kickbacks":      ExerciseInfo(reps: "12 each", sets: "3 sets", tip: "Don't swing your hips", icon: "figure.strengthtraining.functional"),
        "Sumo Squats":          ExerciseInfo(reps: "15 reps", sets: "3 sets", tip: "Feet wide, toes out 45 degrees", icon: "figure.strengthtraining.functional"),
        "Bulgarian Split Squat":ExerciseInfo(reps: "10 each", sets: "3 sets", tip: "Front foot far enough forward", icon: "figure.strengthtraining.functional"),
        "Banded Side Steps":    ExerciseInfo(reps: "20 steps", sets: "3 sets", tip: "Keep band tension throughout", icon: "figure.walk"),
        "Clamshells":           ExerciseInfo(reps: "20 each", sets: "3 sets", tip: "Keep feet together", icon: "figure.strengthtraining.functional"),
        "Single-Leg Glute Bridge": ExerciseInfo(reps: "12 each", sets: "3 sets", tip: "Extend non-working leg straight", icon: "figure.strengthtraining.functional"),
        "Frog Pumps":           ExerciseInfo(reps: "20 reps", sets: "3 sets", tip: "Soles of feet together", icon: "figure.strengthtraining.functional"),
        "Dumbbell Hip Thrusts": ExerciseInfo(reps: "12 reps", sets: "4 sets", tip: "Hold dumbbell on hips", icon: "figure.strengthtraining.traditional"),
        "Reverse Hyperextensions": ExerciseInfo(reps: "15 reps", sets: "3 sets", tip: "Squeeze glutes at top", icon: "figure.strengthtraining.functional"),
        "Squats":               ExerciseInfo(reps: "15 reps", sets: "4 sets", tip: "Knees track over toes", icon: "figure.strengthtraining.traditional"),
        "Lunges":               ExerciseInfo(reps: "12 each", sets: "3 sets", tip: "Keep torso upright", icon: "figure.walk"),
        "Leg Press":            ExerciseInfo(reps: "12 reps", sets: "4 sets", tip: "Don't lock out knees", icon: "figure.strengthtraining.traditional"),
        "Calf Raises":          ExerciseInfo(reps: "20 reps", sets: "3 sets", tip: "Full range of motion", icon: "figure.walk"),
        "Hamstring Curls":      ExerciseInfo(reps: "12 reps", sets: "3 sets", tip: "Slow on the way down", icon: "figure.strengthtraining.functional"),
        "Wall Sit":             ExerciseInfo(reps: "45 sec", sets: "3 sets", tip: "Thighs parallel to floor", icon: "figure.stand"),
        "Step-Ups":             ExerciseInfo(reps: "12 each", sets: "3 sets", tip: "Drive through heel", icon: "figure.walk"),
        "Romanian Deadlift":    ExerciseInfo(reps: "12 reps", sets: "3 sets", tip: "Hinge at hips, soft knees", icon: "figure.strengthtraining.traditional"),
        "Walking Lunges":       ExerciseInfo(reps: "20 steps", sets: "3 sets", tip: "Big controlled steps", icon: "figure.walk"),
        "Reverse Lunges":       ExerciseInfo(reps: "12 each", sets: "3 sets", tip: "Step back, knee hovers floor", icon: "figure.walk"),
        "Jumping Squats":       ExerciseInfo(reps: "15 reps", sets: "3 sets", tip: "Land softly, absorb impact", icon: "figure.jumprope"),
        "Single-Leg Deadlift":  ExerciseInfo(reps: "10 each", sets: "3 sets", tip: "Keep back flat, hinge slowly", icon: "figure.strengthtraining.traditional"),
        "Leg Extensions":       ExerciseInfo(reps: "15 reps", sets: "3 sets", tip: "Squeeze quad at top", icon: "figure.strengthtraining.traditional"),
        "Bicep Curls":          ExerciseInfo(reps: "12 reps", sets: "3 sets", tip: "Elbows pinned to sides", icon: "figure.strengthtraining.traditional"),
        "Hammer Curls":         ExerciseInfo(reps: "12 reps", sets: "3 sets", tip: "Neutral grip, slow down", icon: "figure.strengthtraining.traditional"),
        "Tricep Dips":          ExerciseInfo(reps: "12 reps", sets: "3 sets", tip: "Keep elbows close", icon: "figure.strengthtraining.traditional"),
        "Tricep Pushdowns":     ExerciseInfo(reps: "15 reps", sets: "3 sets", tip: "Lock elbows at sides", icon: "figure.strengthtraining.traditional"),
        "Overhead Tricep Extension": ExerciseInfo(reps: "12 reps", sets: "3 sets", tip: "Keep elbows close to head", icon: "figure.strengthtraining.traditional"),
        "Concentration Curls":  ExerciseInfo(reps: "12 each", sets: "3 sets", tip: "Full squeeze at top", icon: "figure.strengthtraining.traditional"),
        "Skull Crushers":       ExerciseInfo(reps: "12 reps", sets: "3 sets", tip: "Lower bar to forehead slowly", icon: "figure.strengthtraining.traditional"),
        "Diamond Push-Ups":     ExerciseInfo(reps: "10 reps", sets: "3 sets", tip: "Thumbs and index fingers touch", icon: "figure.strengthtraining.traditional"),
        "Deadlift":             ExerciseInfo(reps: "8 reps", sets: "4 sets", tip: "Neutral spine throughout", icon: "figure.strengthtraining.traditional"),
        "Bent-Over Row":        ExerciseInfo(reps: "12 reps", sets: "3 sets", tip: "Squeeze shoulder blades", icon: "figure.strengthtraining.traditional"),
        "Lat Pulldown":         ExerciseInfo(reps: "12 reps", sets: "3 sets", tip: "Pull to upper chest", icon: "figure.strengthtraining.traditional"),
        "Pull-Ups":             ExerciseInfo(reps: "8 reps", sets: "3 sets", tip: "Full hang at bottom", icon: "figure.strengthtraining.traditional"),
        "Face Pulls":           ExerciseInfo(reps: "15 reps", sets: "3 sets", tip: "Pull to ear height", icon: "figure.strengthtraining.traditional"),
        "Superman Hold":        ExerciseInfo(reps: "30 sec", sets: "3 sets", tip: "Squeeze back muscles hard", icon: "figure.cooldown"),
        "Plank":                ExerciseInfo(reps: "45 sec", sets: "3 sets", tip: "Don't let hips sag", icon: "figure.core.training"),
        "Crunches":             ExerciseInfo(reps: "20 reps", sets: "3 sets", tip: "Don't pull on neck", icon: "figure.core.training"),
        "Bicycle Crunches":     ExerciseInfo(reps: "20 each", sets: "3 sets", tip: "Slow and controlled", icon: "figure.core.training"),
        "Leg Raises":           ExerciseInfo(reps: "15 reps", sets: "3 sets", tip: "Lower legs slowly", icon: "figure.core.training"),
        "Russian Twists":       ExerciseInfo(reps: "20 reps", sets: "3 sets", tip: "Lean back slightly", icon: "figure.core.training"),
        "Mountain Climbers":    ExerciseInfo(reps: "30 sec", sets: "3 sets", tip: "Keep hips level", icon: "figure.run"),
        "Dead Bug":             ExerciseInfo(reps: "10 each", sets: "3 sets", tip: "Press lower back into floor", icon: "figure.core.training"),
        "Side Plank":           ExerciseInfo(reps: "30 each", sets: "3 sets", tip: "Keep body straight", icon: "figure.core.training"),
        "Burpees":              ExerciseInfo(reps: "12 reps", sets: "3 sets", tip: "Land softly on jump", icon: "figure.jumprope"),
        "Push-Ups":             ExerciseInfo(reps: "15 reps", sets: "3 sets", tip: "Chest to floor, core tight", icon: "figure.strengthtraining.traditional"),
        "Kettlebell Swings":    ExerciseInfo(reps: "15 reps", sets: "3 sets", tip: "Hip hinge not squat", icon: "figure.strengthtraining.traditional"),
        "Box Jumps":            ExerciseInfo(reps: "10 reps", sets: "3 sets", tip: "Land with soft knees", icon: "figure.jumprope"),
    ]

    func infoFor(_ name: String) -> ExerciseInfo {
        exerciseInfoMap[name] ?? ExerciseInfo(reps: "12 reps", sets: "3 sets", tip: "Focus on form", icon: "figure.strengthtraining.traditional")
    }

    var body: some View {
        ZStack {
            brown.ignoresSafeArea()
            if showSetup {
                setupView
            } else if isHydrationBreak {
                hydrationBreakView
            } else {
                workoutView
            }
        }
        .sheet(isPresented: $showSaveRoutine) { saveRoutineSheet }
        .sheet(isPresented: $showCompletionSheet) { completionSheet }
        .sheet(isPresented: $showMusicPicker) {
            MusicPickerView(musicService: musicService, isPresented: $showMusicPicker)
        }
        .onChange(of: timerService.isWorkoutComplete) { _, complete in
            if complete { showCompletionSheet = true }
        }
        .onChange(of: timerService.currentExerciseIndex) { oldVal, newVal in
            if newVal > oldVal && !showSetup { triggerHydrationBreak() }
        }
    }

    func triggerHydrationBreak() {
        timerService.stopTimer()
        isHydrationBreak = true
        hydrationTimeLeft = 30
        hydrationTimer?.invalidate()
        hydrationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if hydrationTimeLeft > 1 {
                hydrationTimeLeft -= 1
            } else {
                hydrationTimer?.invalidate()
                isHydrationBreak = false
                timerService.startTimer()
            }
        }
    }

    var hydrationBreakView: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "drop.fill")
                .font(.system(size: 70))
                .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))
            Text("Hydration Break!")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text("Grab some water")
                .font(.title3).foregroundColor(.white.opacity(0.7))

            ZStack {
                Circle().stroke(Color.white.opacity(0.1), lineWidth: 10).frame(width: 140, height: 140)
                Circle()
                    .trim(from: 0, to: CGFloat(hydrationTimeLeft) / 30.0)
                    .stroke(Color(red: 0.4, green: 0.7, blue: 1.0), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: hydrationTimeLeft)
                Circle().fill(Color.white).frame(width: 110, height: 110)
                VStack(spacing: 2) {
                    Text("\(hydrationTimeLeft)").font(.system(size: 40, weight: .bold)).foregroundColor(.black)
                    Text("sec").font(.caption).foregroundColor(.gray)
                }
            }

            if !timerService.exerciseList.isEmpty && timerService.currentExerciseIndex < timerService.exerciseList.count {
                let next = timerService.exerciseList[timerService.currentExerciseIndex]
                VStack(spacing: 6) {
                    Text("UP NEXT").font(.caption).fontWeight(.bold).foregroundColor(accent.opacity(0.8)).tracking(2)
                    Text(next.name).font(.title2).fontWeight(.semibold).foregroundColor(.white)
                    Text("\(infoFor(next.name).sets)  \u{2022}  \(infoFor(next.name).reps)").font(.subheadline).foregroundColor(.white.opacity(0.6))
                }
                .padding(16).frame(maxWidth: .infinity)
                .background(cardBg).cornerRadius(16).padding(.horizontal, 30)
            }

            Button {
                hydrationTimer?.invalidate(); isHydrationBreak = false; timerService.startTimer()
            } label: {
                Text("Skip Break").font(.subheadline).foregroundColor(.white.opacity(0.5))
            }
            Spacer()
        }
    }

    var setupView: some View {
        ScrollView {
            VStack(spacing: 28) {
                HStack {
                    Text("Sculpted Set").font(.title).fontWeight(.bold).foregroundColor(accent)
                    Spacer()
                }
                .padding(.horizontal).padding(.top, 10)

                VStack(alignment: .leading, spacing: 12) {
                    Text("What are we training today?")
                        .font(.title2).fontWeight(.bold).foregroundColor(.white).padding(.horizontal)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(bodyParts, id: \.self) { part in
                            Button { timerService.selectBodyPart(part) } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: iconFor(part)).font(.system(size: 28))
                                        .foregroundColor(timerService.selectedBodyPart == part ? .white : accent)
                                    Text(part).font(.subheadline).fontWeight(.semibold).foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity).frame(height: 90)
                                .background(timerService.selectedBodyPart == part ? medBrown : Color.white.opacity(0.08))
                                .cornerRadius(14)
                                .overlay(RoundedRectangle(cornerRadius: 14)
                                    .stroke(timerService.selectedBodyPart == part ? accent : Color.clear, lineWidth: 2))
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("How long?").font(.title2).fontWeight(.bold).foregroundColor(.white).padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(minutes, id: \.self) { min in
                                Button { timerService.updateWorkoutDuration(mins: min) } label: {
                                    Text("\(min)m").font(.subheadline).fontWeight(.semibold)
                                        .foregroundColor(timerService.selectedMins == min ? .white : .white.opacity(0.7))
                                        .frame(width: 56, height: 44)
                                        .background(timerService.selectedMins == min ? medBrown : Color.white.opacity(0.08))
                                        .cornerRadius(10)
                                        .overlay(RoundedRectangle(cornerRadius: 10)
                                            .stroke(timerService.selectedMins == min ? accent : Color.clear, lineWidth: 1.5))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                if !timerService.exerciseList.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your workout (\(timerService.exerciseList.count) exercises)")
                            .font(.subheadline).foregroundColor(.white.opacity(0.6)).padding(.horizontal)
                        VStack(spacing: 0) {
                            ForEach(Array(timerService.exerciseList.enumerated()), id: \.offset) { index, exercise in
                                HStack {
                                    Text("\(index + 1).").font(.subheadline).foregroundColor(accent).frame(width: 28, alignment: .leading)
                                    Text(exercise.name).font(.subheadline).foregroundColor(.white)
                                    Spacer()
                                    Text("\(exercise.duration) min").font(.caption).foregroundColor(.white.opacity(0.5))
                                    Button {
                                        if workoutStore.isFavoriteExercise(name: exercise.name) {
                                            if let fav = workoutStore.favoriteExercises.first(where: { $0.name == exercise.name }) {
                                                workoutStore.removeFavoriteExercise(id: fav.id)
                                            }
                                        } else {
                                            workoutStore.addFavoriteExercise(name: exercise.name, bodyPart: timerService.selectedBodyPart)
                                        }
                                    } label: {
                                        Image(systemName: workoutStore.isFavoriteExercise(name: exercise.name) ? "heart.fill" : "heart")
                                            .foregroundColor(workoutStore.isFavoriteExercise(name: exercise.name) ? .red : .white.opacity(0.3))
                                            .font(.system(size: 14))
                                    }
                                }
                                .padding(.horizontal, 16).padding(.vertical, 10)
                                .background(index % 2 == 0 ? Color.white.opacity(0.05) : Color.clear)
                            }
                        }
                        .background(Color.white.opacity(0.05)).cornerRadius(12).padding(.horizontal)
                        Button { showSaveRoutine = true } label: {
                            Label("Save as Favorite Routine", systemImage: "bookmark")
                                .font(.subheadline).foregroundColor(accent).padding(.horizontal)
                        }
                    }
                }

                Button {
                    if timerService.selectedBodyPart.isEmpty { timerService.selectBodyPart("Full Body") }
                    showSetup = false
                    timerService.startTimer()
                } label: {
                    Text(timerService.selectedBodyPart.isEmpty ? "Start Workout" : "Start \(timerService.selectedBodyPart) Workout")
                        .font(.headline).frame(maxWidth: .infinity).frame(height: 56)
                        .background(medBrown).foregroundColor(.white).cornerRadius(14).padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
        }
    }

    var workoutView: some View {
        VStack(spacing: 0) {
            HStack {
                Button { timerService.stopTimer(); showSetup = true } label: {
                    Image(systemName: "chevron.left").foregroundColor(.white).font(.title3)
                }
                Text(timerService.selectedBodyPart).font(.title2).fontWeight(.bold).foregroundColor(accent)
                Spacer()
                // Music button
                Button { showMusicPicker = true } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "music.note")
                            .font(.system(size: 14))
                        Text(musicService.selectedMood.isEmpty ? "Music" : musicService.selectedMood)
                            .font(.caption).fontWeight(.semibold)
                    }
                    .foregroundColor(musicService.selectedMood.isEmpty ? .white.opacity(0.6) : accent)
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(10)
                }
                Text("\(timerService.selectedMins) min").font(.subheadline).foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal).padding(.top, 10).padding(.bottom, 16)

            if !timerService.exerciseList.isEmpty {
                let exercise = timerService.exerciseList[timerService.currentExerciseIndex]
                let info = infoFor(exercise.name)
                let total = Double(exercise.duration * 60)
                let elapsed = timerService.getCurrentExerciseElapsedTime()
                let progress = max(0, min(1, 1 - (elapsed / total)))

                // TOP: Timer + Info side by side
                HStack(alignment: .center, spacing: 16) {
                    ZStack {
                        Circle().stroke(Color.white.opacity(0.08), lineWidth: 10).frame(width: 150, height: 150)
                        Circle()
                            .trim(from: 0, to: CGFloat(progress))
                            .stroke(accent, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .frame(width: 150, height: 150)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: progress)
                        Circle().fill(Color.white).frame(width: 120, height: 120).shadow(color: .black.opacity(0.2), radius: 4)
                        VStack(spacing: 2) {
                            Text(timerService.timeString(timerService.timeRemaining))
                                .font(.system(size: 26, weight: .bold, design: .rounded)).foregroundColor(.black)
                            Text("left").font(.caption2).foregroundColor(.gray)
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text(exercise.name)
                            .font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.white)
                            .lineLimit(2).fixedSize(horizontal: false, vertical: true)

                        HStack(spacing: 6) {
                            Text("Now").font(.caption2).fontWeight(.bold).foregroundColor(.white)
                                .padding(.horizontal, 8).padding(.vertical, 3).background(medBrown).cornerRadius(6)
                            Text("\(exercise.duration) min").font(.caption).foregroundColor(accent)
                        }

                        if timerService.currentExerciseIndex + 1 < timerService.exerciseList.count {
                            let next = timerService.exerciseList[timerService.currentExerciseIndex + 1]
                            HStack(spacing: 6) {
                                Text("Next").font(.caption2).fontWeight(.bold).foregroundColor(.white.opacity(0.6))
                                    .padding(.horizontal, 8).padding(.vertical, 3).background(Color.white.opacity(0.1)).cornerRadius(6)
                                Text(next.name).font(.caption).foregroundColor(.white.opacity(0.6)).lineLimit(1)
                            }
                        }
                        Text("\(timerService.currentExerciseIndex + 1) of \(timerService.exerciseList.count)")
                            .font(.caption2).foregroundColor(.white.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal).padding(.bottom, 16)

                // MIDDLE: Exercise card
                VStack(spacing: 0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16).fill(cardBg)
                        VStack(spacing: 14) {
                            ZStack {
                                Circle().fill(medBrown.opacity(0.5)).frame(width: 90, height: 90)
                                Image(systemName: info.icon).font(.system(size: 44)).foregroundColor(accent)
                            }
                            Text(exercise.name).font(.title3).fontWeight(.bold).foregroundColor(.white)
                            HStack(spacing: 0) {
                                statPill(value: info.sets, label: "Sets")
                                Divider().frame(height: 30).background(Color.white.opacity(0.15))
                                statPill(value: info.reps, label: "Reps")
                                Divider().frame(height: 30).background(Color.white.opacity(0.15))
                                statPill(value: "30s", label: "Break")
                            }
                            .background(Color.white.opacity(0.06)).cornerRadius(12).padding(.horizontal)
                            HStack(spacing: 8) {
                                Image(systemName: "lightbulb.fill").foregroundColor(.yellow.opacity(0.8)).font(.caption)
                                Text(info.tip).font(.caption).foregroundColor(.white.opacity(0.7)).lineLimit(2)
                            }
                            .padding(.horizontal).padding(.bottom, 4)
                        }
                        .padding(.vertical, 16)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Progress bar
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Workout Progress").font(.caption).foregroundColor(.white.opacity(0.6))
                        Spacer()
                        Text("\(Int(timerService.getOverallProgress() * 100))%").font(.caption).fontWeight(.medium).foregroundColor(.white.opacity(0.8))
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle().foregroundColor(Color.white.opacity(0.12)).frame(width: geo.size.width, height: 8).cornerRadius(4)
                            Rectangle().foregroundColor(accent)
                                .frame(width: geo.size.width * CGFloat(timerService.getOverallProgress()), height: 8).cornerRadius(4)
                                .animation(.linear(duration: 1), value: timerService.getOverallProgress())
                        }
                    }
                    .frame(height: 8)
                }
                .padding(.horizontal)

                HStack(spacing: 20) {
                    Button {
                        if timerService.isTimerRunning { timerService.stopTimer() } else { timerService.startTimer() }
                    } label: {
                        Image(systemName: timerService.isTimerRunning ? "pause.fill" : "play.fill")
                            .font(.title).frame(width: 64, height: 64)
                            .background(medBrown).foregroundColor(.white)
                            .clipShape(Circle()).shadow(color: .black.opacity(0.4), radius: 6)
                    }
                    Button { timerService.resetTimer(); showSetup = true } label: {
                        Text("Reset").font(.headline).frame(width: 90, height: 64)
                            .background(Color.white.opacity(0.10)).foregroundColor(.white).clipShape(Capsule())
                    }
                }
                .padding(.top, 10).padding(.bottom, 20)
            }
        }
    }

    func statPill(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.subheadline).fontWeight(.bold).foregroundColor(.white)
            Text(label).font(.caption2).foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity).padding(.vertical, 10)
    }

    var saveRoutineSheet: some View {
        ZStack {
            brown.ignoresSafeArea()
            VStack(spacing: 24) {
                Text("Save Routine").font(.title2).fontWeight(.bold).foregroundColor(.white).padding(.top, 30)
                TextField("", text: $routineName, prompt: Text("Routine name e.g. Glute Day").foregroundColor(.black.opacity(0.4)))
                    .foregroundColor(.black).padding().background(Color.white).cornerRadius(12).padding(.horizontal, 24)
                Button {
                    let name = routineName.isEmpty ? "\(timerService.selectedBodyPart) Routine" : routineName
                    workoutStore.addFavoriteRoutine(name: name, bodyPart: timerService.selectedBodyPart,
                        durationMins: timerService.selectedMins, exercises: timerService.exerciseList.map { $0.name })
                    showSaveRoutine = false; routineName = ""
                } label: {
                    Text("Save").font(.headline).frame(maxWidth: .infinity).frame(height: 54)
                        .background(medBrown).foregroundColor(.white).cornerRadius(14).padding(.horizontal, 24)
                }
                Button { showSaveRoutine = false } label: { Text("Cancel").foregroundColor(.white.opacity(0.5)) }
                Spacer()
            }
        }
    }

    var completionSheet: some View {
        ZStack {
            brown.ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "checkmark.circle.fill").font(.system(size: 70)).foregroundColor(accent)
                Text("Workout Complete!").font(.title).fontWeight(.bold).foregroundColor(.white)
                Text("\(timerService.selectedMins) min \(timerService.selectedBodyPart) session").foregroundColor(.white.opacity(0.6))
                Button {
                    workoutStore.saveSession(WorkoutSession(date: Date(), durationMins: timerService.selectedMins,
                        bodyPart: timerService.selectedBodyPart, exercises: timerService.exerciseList.map { $0.name }))
                    showCompletionSheet = false; showSetup = true; timerService.resetTimer()
                } label: {
                    Text("Save & Finish").font(.headline).frame(maxWidth: .infinity).frame(height: 56)
                        .background(medBrown).foregroundColor(.white).cornerRadius(14).padding(.horizontal, 30)
                }
                Button { showCompletionSheet = false; showSetup = true; timerService.resetTimer() } label: {
                    Text("Dismiss").foregroundColor(.white.opacity(0.4))
                }
                Spacer()
            }
        }
    }

    func iconFor(_ part: String) -> String {
        switch part {
        case "Glutes": return "figure.strengthtraining.functional"
        case "Legs": return "figure.walk"
        case "Arms": return "figure.strengthtraining.traditional"
        case "Back": return "figure.cooldown"
        case "Core": return "flame.fill"
        case "Full Body": return "bolt.fill"
        default: return "dumbbell"
        }
    }
}

#Preview {
    TimerView().environmentObject(WorkoutStore())
}



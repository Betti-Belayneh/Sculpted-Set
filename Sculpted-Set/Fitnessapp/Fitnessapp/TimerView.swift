//
//  TimerView.swift
//  Fitnessapp
//
//  Created by Miriam on 4/8/25.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var timerService = TimerService()
    @State private var showDurationPicker = false
    
    let minutes = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
     
    var body: some View {
       
        ZStack {
           
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
             
                HStack {
                    // App name
                    Text("Sculpted Set")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                
                Spacer()
              
                ZStack {
                    Circle()
                        .stroke(Color(UIColor.systemGray5), lineWidth: 10)
                        .frame(width: 260, height: 260)
                    
                
                    if timerService.isTimerRunning {
                        let currentExercise = timerService.exerciseList[timerService.currentExerciseIndex]
                        let totalExerciseSeconds = currentExercise.duration * 60
                        let exerciseElapsedTime = timerService.getCurrentExerciseElapsedTime()
                        let progress = 1 - (exerciseElapsedTime / Double(totalExerciseSeconds))
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(progress))
                            .stroke(Color(.purple), lineWidth: 10)
                            .frame(width: 260, height: 260)
                            .rotationEffect(.degrees(-90))
                    }
                    
              
                    Circle()
                        .fill(Color.white)
                        .frame(width: 220, height: 220)
                        .shadow(radius: 2)
                    
               
                    VStack {
                        if !timerService.isTimerRunning && showDurationPicker {
                            Picker("Select Minutes", selection: $timerService.selectedMins) {
                                ForEach(minutes, id: \.self) { minute in
                                    Text("\(minute)").tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 100)
                            .onChange(of: timerService.selectedMins) { _, newValue in
                                timerService.updateWorkoutDuration(mins: newValue)
                            }
                            
                            Text("minutes")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            Text(timerService.timeString(timerService.timeRemaining))
                                .font(.system(size: 54, weight: .bold))
                                .onTapGesture {
                                    if !timerService.isTimerRunning {
                                        showDurationPicker.toggle()
                                    }
                                }
                            
                            Text("remaining")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.vertical, 10)
                
                Spacer()
                
                if !timerService.exerciseList.isEmpty {
                    VStack(alignment: .center) {
                        Text(timerService.exerciseList[timerService.currentExerciseIndex].name)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding(.horizontal)
                    }
                }
                Spacer()
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Workout Progress")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("\(Int(timerService.getOverallProgress() * 100))%")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    
                  
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundColor(Color(UIColor.systemGray5))
                                .frame(width: geometry.size.width, height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .foregroundColor(.green)
                                .frame(width: geometry.size.width * CGFloat(timerService.getOverallProgress()), height: 8)
                                .cornerRadius(4)
                        }
                    }
                    .frame(height: 8)
                }
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    Button(action: {
                        if timerService.isTimerRunning {
                            timerService.stopTimer()
                        } else {
                            showDurationPicker = false
                            timerService.startTimer()
                        }
                    }) {
                        Image(systemName: timerService.isTimerRunning ? "pause.fill" : "play.fill")
                            .font(.title)
                            .frame(width: 60, height: 60)
                            .background(.purple)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
                    Button(action: {
                        timerService.resetTimer()
                        showDurationPicker = false
                    }) {
                        Text("Reset")
                            .font(.headline)
                            .frame(width: 80, height: 60)
                            .background(Color(UIColor.systemGray5))
                            .foregroundColor(.primary)
                            .clipShape(Capsule())
                    }
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.vertical)
        }
    }
    
}

#Preview{
    TimerView()
}

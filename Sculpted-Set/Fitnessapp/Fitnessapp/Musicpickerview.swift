//
//  Musicpickerview.swift
//  Fitnessapp
//
//  Created by Betti 
//

import SwiftUI

struct MusicPickerView: View {
    @ObservedObject var musicService: MusicService
    @Binding var isPresented: Bool

    let brown = Color(red: 0.18, green: 0.10, blue: 0.05)
    let accent = Color(red: 0.76, green: 0.49, blue: 0.27)
    let medBrown = Color(red: 0.48, green: 0.25, blue: 0.10)
    let cardBg = Color(red: 0.25, green: 0.14, blue: 0.07)

    let moodColors: [String: Color] = [
        "Hype":       Color(red: 1.0, green: 0.6, blue: 0.1),
        "Chill":      Color(red: 0.4, green: 0.7, blue: 1.0),
        "Focused":    Color(red: 0.5, green: 0.9, blue: 0.6),
        "Aggressive": Color(red: 1.0, green: 0.3, blue: 0.3)
    ]

    var body: some View {
        ZStack {
            brown.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    // Handle bar
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)

                    // Header
                    VStack(spacing: 6) {
                        Image(systemName: "music.note")
                            .font(.system(size: 36))
                            .foregroundColor(accent)
                        Text("Workout Playlist")
                            .font(.title2).fontWeight(.bold).foregroundColor(.white)
                        Text("Pick your vibe and we'll open the perfect playlist")
                            .font(.subheadline).foregroundColor(.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }

                    // Mood selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What's your mood?")
                            .font(.headline).fontWeight(.bold).foregroundColor(.white)
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(musicService.moods, id: \.self) { mood in
                                Button { musicService.selectedMood = mood } label: {
                                    HStack(spacing: 10) {
                                        Image(systemName: musicService.moodIcons[mood] ?? "music.note")
                                            .font(.system(size: 20))
                                            .foregroundColor(musicService.selectedMood == mood ? .white : (moodColors[mood] ?? accent))
                                        Text(mood)
                                            .font(.subheadline).fontWeight(.semibold)
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity).frame(height: 60)
                                    .background(musicService.selectedMood == mood ? (moodColors[mood] ?? accent).opacity(0.4) : Color.white.opacity(0.07))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(musicService.selectedMood == mood ? (moodColors[mood] ?? accent) : Color.clear, lineWidth: 2)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Genre selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What's your genre?")
                            .font(.headline).fontWeight(.bold).foregroundColor(.white)
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(musicService.genres, id: \.self) { genre in
                                Button { musicService.selectedGenre = genre } label: {
                                    VStack(spacing: 6) {
                                        Image(systemName: musicService.genreIcons[genre] ?? "music.note")
                                            .font(.system(size: 20))
                                            .foregroundColor(musicService.selectedGenre == genre ? .white : accent)
                                        Text(genre)
                                            .font(.caption).fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity).frame(height: 72)
                                    .background(musicService.selectedGenre == genre ? medBrown : Color.white.opacity(0.07))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(musicService.selectedGenre == genre ? accent : Color.clear, lineWidth: 2)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Playlist preview card
                    if !musicService.selectedMood.isEmpty && !musicService.selectedGenre.isEmpty {
                        VStack(spacing: 12) {
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(medBrown)
                                        .frame(width: 56, height: 56)
                                    Image(systemName: "music.note.list")
                                        .font(.system(size: 24))
                                        .foregroundColor(accent)
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(musicService.selectedMood) \(musicService.selectedGenre)")
                                        .font(.headline).foregroundColor(.white)
                                    Text("Curated workout playlist")
                                        .font(.caption).foregroundColor(.white.opacity(0.5))
                                }
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .foregroundColor(accent).font(.title3)
                            }
                            .padding(14)
                            .background(cardBg)
                            .cornerRadius(14)
                            .padding(.horizontal)
                        }
                    }

                    // Open playlist button
                    Button {
                        musicService.openPlaylist()
                        isPresented = false
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "music.note")
                            Text(musicService.selectedMood.isEmpty || musicService.selectedGenre.isEmpty
                                 ? "Select mood & genre first"
                                 : "Open in Apple Music")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity).frame(height: 56)
                        .background(musicService.selectedMood.isEmpty || musicService.selectedGenre.isEmpty
                                    ? Color.white.opacity(0.15) : medBrown)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .padding(.horizontal)
                    }
                    .disabled(musicService.selectedMood.isEmpty || musicService.selectedGenre.isEmpty)

                    // Skip option
                    Button { isPresented = false } label: {
                        Text("Skip for now")
                            .font(.subheadline).foregroundColor(.white.opacity(0.4))
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

#Preview {
    MusicPickerView(musicService: MusicService(), isPresented: .constant(true))
}

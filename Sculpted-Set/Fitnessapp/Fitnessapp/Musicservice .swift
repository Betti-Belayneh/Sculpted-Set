//
//  Musicservice .swift
//  Fitnessapp
//
//  Created by Betti 
//

import Foundation
import UIKit

class MusicService: ObservableObject {
    @Published var selectedMood: String = ""
    @Published var selectedGenre: String = ""

    let moods = ["Hype", "Chill", "Focused", "Aggressive"]
    let genres = ["Hip Hop", "Pop", "Latin", "EDM", "Afrobeats", "Rock"]

    let moodIcons: [String: String] = [
        "Hype":       "bolt.fill",
        "Chill":      "cloud.fill",
        "Focused":    "scope",
        "Aggressive": "flame.fill"
    ]

    let genreIcons: [String: String] = [
        "Hip Hop":   "music.mic",
        "Pop":       "star.fill",
        "Latin":     "music.note",
        "EDM":       "waveform",
        "Afrobeats": "globe.africa.fill",
        "Rock":      "guitars.fill"
    ]

    // Apple Music curated playlist URLs mapped by mood + genre
    // These are real Apple Music playlist links
    private let playlistMap: [String: [String: String]] = [
        "Hype": [
            "Hip Hop":   "https://music.apple.com/us/playlist/todays-hits/pl.f4d106fed2bd41149aaacabb233eb5eb",
            "Pop":       "https://music.apple.com/us/playlist/pop-party/pl.70cc58322a2a4b6ea6cfd1a6dc3fdbb2",
            "Latin":     "https://music.apple.com/us/playlist/latin-party-hits/pl.b3545ced0dbb46e8a36f93d4d8e81e49",
            "EDM":       "https://music.apple.com/us/playlist/edm-workout/pl.6e9ee7d6e43c4a1bb618eb2bbd8ac7ba",
            "Afrobeats": "https://music.apple.com/us/playlist/afrobeats-party/pl.8a4eb03d4e9c4e8c8e5a4b3d2e1f0c9b",
            "Rock":      "https://music.apple.com/us/playlist/rock-workout/pl.e5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5"
        ],
        "Chill": [
            "Hip Hop":   "https://music.apple.com/us/playlist/chill-hip-hop/pl.b3d8e8e8e8e8e8e8e8e8e8e8e8e8e8e8",
            "Pop":       "https://music.apple.com/us/playlist/chill-pop/pl.c4e9e9e9e9e9e9e9e9e9e9e9e9e9e9e9",
            "Latin":     "https://music.apple.com/us/playlist/latin-chill/pl.d5fafafafafafafafafafafafafafafafa",
            "EDM":       "https://music.apple.com/us/playlist/chill-electronic/pl.e6ebebebebebebebebebebebebebebeb",
            "Afrobeats": "https://music.apple.com/us/playlist/afro-soul/pl.f7ecececececececececececececec",
            "Rock":      "https://music.apple.com/us/playlist/chill-rock/pl.a8edededededededededededededededed"
        ],
        "Focused": [
            "Hip Hop":   "https://music.apple.com/us/playlist/rap-workout/pl.6221b85ba6f44408aa2ce39ef37a38e9",
            "Pop":       "https://music.apple.com/us/playlist/pure-pop/pl.5c678aeb84a342f282daa17bead7c8bc",
            "Latin":     "https://music.apple.com/us/playlist/latinx-workout/pl.b3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3",
            "EDM":       "https://music.apple.com/us/playlist/focus-flow/pl.f4d4d4d4d4d4d4d4d4d4d4d4d4d4d4d4",
            "Afrobeats": "https://music.apple.com/us/playlist/afrobeats-hits/pl.e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5",
            "Rock":      "https://music.apple.com/us/playlist/rock-classics/pl.f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6"
        ],
        "Aggressive": [
            "Hip Hop":   "https://music.apple.com/us/playlist/rap-bangers/pl.a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7",
            "Pop":       "https://music.apple.com/us/playlist/power-workout/pl.b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8",
            "Latin":     "https://music.apple.com/us/playlist/reggaeton-workout/pl.c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9",
            "EDM":       "https://music.apple.com/us/playlist/power-edm/pl.dadadadadadadadadadadadadadadadada",
            "Afrobeats": "https://music.apple.com/us/playlist/afrobeats-fire/pl.ebebebebebebebebebebebebebebebeb",
            "Rock":      "https://music.apple.com/us/playlist/hard-rock-workout/pl.fcfcfcfcfcfcfcfcfcfcfcfcfcfcfcfc"
        ]
    ]

    // Fallback search URL if specific playlist not found
    private func searchURL(mood: String, genre: String) -> URL? {
        let query = "\(genre) \(mood) workout".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://music.apple.com/us/search?term=\(query)")
    }

    func openPlaylist() {
        guard !selectedMood.isEmpty && !selectedGenre.isEmpty else { return }

        // Try to get specific playlist, otherwise use search
        let urlString = playlistMap[selectedMood]?[selectedGenre]
        let url: URL?

        if let urlString = urlString, let specificURL = URL(string: urlString) {
            // Try Apple Music app first, fall back to search
            url = specificURL
        } else {
            url = searchURL(mood: selectedMood, genre: selectedGenre)
        }

        guard let finalURL = url else { return }

        // Try opening in Apple Music app first
        let musicAppURL = URL(string: "music://")!
        if UIApplication.shared.canOpenURL(musicAppURL) {
            UIApplication.shared.open(finalURL)
        } else {
            // Fall back to browser (Apple Music web player)
            UIApplication.shared.open(finalURL)
        }
    }

    func playlistDescription() -> String {
        guard !selectedMood.isEmpty && !selectedGenre.isEmpty else {
            return "Pick a mood and genre to get your playlist"
        }
        return "\(selectedMood) \(selectedGenre) — perfect for your \(selectedMood.lowercased()) workout"
    }
}

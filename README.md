🏋️‍♀️ Sculpted Set
Sculpted Set is a SwiftUI-based fitness timer app designed to help users engage in structured, time-based lower-body workouts. The app provides randomized exercise routines, visual timers, and motivational audio cues to enhance your workout experience.

🚀 Features
🔐 Login & Signup: Simple onboarding with email and password.

🕒 Customizable Workout Timer: Choose workout durations and follow guided timed sessions.

🔄 Randomized Exercises: Auto-generated leg-focused workout routines every session.

🔊 Motivational Audio Cues: Get sound alerts for transitions and the last minute.

📊 Progress Tracking UI: Visual feedback for session progress and current activity.

📱 Multi-tab Navigation: Easily switch between Workout, Progress, Favorites, and More sections.

📸 Screenshots
Add screenshots or a GIF demo here

📂 File Structure
ContentView.swift – Landing page with navigation to Login and Signup.

LoginView.swift – User login interface.

SignUpService.swift – Handles in-memory signup logic.

TabsView.swift – Main navigation with tabs.

TimerView.swift – Core workout screen with dynamic timer and progress.

TimerService.swift – Manages workout logic, time tracking, and audio playback.

FitnessappApp.swift – App entry point.

princess-sound.mp3 – Audio cue for the final minute of a session.

🛠 Technologies Used
SwiftUI

AVFoundation (for audio)

MVVM-style separation using ObservableObject

📦 Installation
Clone the repository:

bash
Copy
Edit
git clone https://github.com/your-username/sculpted-set.git
Open in Xcode 15+:

bash
Copy
Edit
open SculptedSet.xcodeproj
Run the project on an iOS simulator or a physical device.

⚠️ This project currently uses in-memory storage for user accounts (no backend).

📌 To-Do
 Add persistent user auth

 Expand exercise categories

 Implement real progress tracking

 Polish UI and animations

👩‍💻 Author
Betti

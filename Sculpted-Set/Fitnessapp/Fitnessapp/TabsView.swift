/
//  TabsView.swift
//  Fitnessapp
//created by Betti
//

import SwiftUI

struct TabsView: View {
    @ObservedObject var signUpService: SignUpService
    @EnvironmentObject var workoutStore: WorkoutStore
    @EnvironmentObject var healthKit: HealthKitService

    let accent = Color(red: 0.76, green: 0.49, blue: 0.27)

    var body: some View {
        TabView {
            TimerView()
                .environmentObject(workoutStore)
                .tabItem { Label("Workout", systemImage: "dumbbell") }

            WorkoutProgressView()
                .environmentObject(workoutStore)
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }

            HealthView()
                .environmentObject(healthKit)
                .tabItem { Label("Health", systemImage: "heart.fill") }

            FavoritesView()
                .environmentObject(workoutStore)
                .tabItem { Label("Favorites", systemImage: "bookmark.fill") }

            MoreView(signUpService: signUpService)
                .tabItem { Label("More", systemImage: "ellipsis") }
        }
        .tint(accent)
    }
}

struct MoreView: View {
    @ObservedObject var signUpService: SignUpService

    let brown = Color(red: 0.18, green: 0.10, blue: 0.05)
    let accent = Color(red: 0.76, green: 0.49, blue: 0.27)
    let medBrown = Color(red: 0.48, green: 0.25, blue: 0.10)

    var body: some View {
        ZStack {
            brown.ignoresSafeArea()
            VStack(spacing: 0) {
                Text("More")
                    .font(.title2).fontWeight(.bold).foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 16)

                if let user = signUpService.getCurrentUser() {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle().fill(medBrown).frame(width: 50, height: 50)
                            Text(String(user.firstName.prefix(1)).uppercased())
                                .font(.title2).fontWeight(.bold).foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("\(user.firstName) \(user.lastName)")
                                .font(.headline).foregroundColor(.white)
                            Text(user.email)
                                .font(.subheadline).foregroundColor(.white.opacity(0.5))
                        }
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(14)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }

                Spacer()

                Button { signUpService.logoutUser() } label: {
                    Text("Log Out")
                        .font(.headline).frame(maxWidth: .infinity).frame(height: 54)
                        .background(Color.red.opacity(0.75)).foregroundColor(.white)
                        .cornerRadius(14).padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    MoreView(signUpService: SignUpService())
}

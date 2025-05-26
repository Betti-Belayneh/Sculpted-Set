//
//  TabView.swift
//  Fitnessapp
//
//  Created by Miriam on 5/4/25.
//

import SwiftUI

struct TabsView: View {
    var body: some View {
        TabView {
          
            // 1
            Tab( "Workout", systemImage: "dumbbell") {
               TimerView()
            }
            
            Tab("Progress", systemImage: "figure.walk") {
                FutureView()
            }
           
            
            // 3
            Tab( "Favorites", systemImage: "heart") {
                FutureView()
            }
            
            Tab( "More", systemImage: "ellipsis") {
                MoreView()
            }
        }
    }
}

struct FutureView: View {
    var body: some View {
        Text("Coming")
            .italic()
            
        Text("Soon")
            .italic()
        
    }
}

struct MoreView: View {
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 10) {
                
                Text("More")
                
                NavigationLink(destination: MoreView()) {
                    HStack {
                        Image(systemName: "person.circle")
                        Text("My Account")
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemBackground))
                    .contentShape(Rectangle())
                }

                NavigationLink(destination: MoreView()) {
                    HStack {
                        Image(systemName: "gearshape")
                        Text("Settings")
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemBackground))
                    .contentShape(Rectangle())
                }

                NavigationLink(destination: MoreView()) {
                    HStack {
                        Image(systemName: "lock.shield")
                        Text("Privacy")
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemBackground))
                    .contentShape(Rectangle())
                }

                NavigationLink(destination: MoreView()) {
                    HStack {
                        Image(systemName: "questionmark.circle")
                        Text("Help")
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemBackground))
                    .contentShape(Rectangle())
                }

                Spacer()
            }
          
        }
    }
}
#Preview {
    MoreView()
}

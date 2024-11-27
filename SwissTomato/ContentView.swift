//
//  ContentView.swift
//  SwissTomato
//
//  Created by Zian Chen on 11/26/24.
//

import SwiftUI
import UserNotifications

// Main view
struct ContentView: View {
    @StateObject private var pomodoroTimer = PomodoroTimer()
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text(timeString(from: pomodoroTimer.timeRemaining))
                .font(.system(size: 60, weight: .bold))
                .monospacedDigit()
            
            Text(pomodoroTimer.statusText)
                .font(.title2)
                .foregroundColor(.secondary)
            
            HStack(spacing: 20) {
                if pomodoroTimer.state == .running {
                    Button(action: { pomodoroTimer.pauseTimer() }) {
                        Image(systemName: "pause.circle.fill")
                            .font(.system(size: 50))
                    }
                } else {
                    Button(action: { pomodoroTimer.startTimer() }) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 50))
                    }
                }
                
                Button(action: { pomodoroTimer.resetTimer() }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 50))
                }
            }
            
            Button("Settings") {
                showingSettings = true
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(workDuration: $pomodoroTimer.workDuration,
                            breakDuration: $pomodoroTimer.breakDuration)
            }
        }
        .padding()
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    // Make sure to clean up when the app goes to background
    func applicationWillResignActive() {
        UIApplication.shared.isIdleTimerDisabled = false
    }

    // Optional: Reset screen lock when coming back to foreground if timer is running
    func applicationDidBecomeActive() {
        if pomodoroTimer.state == .running {
            UIApplication.shared.isIdleTimerDisabled = true
                    
        }
    }
}

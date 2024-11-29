//
//  PomodoroTimer.swift
//  SwissTomato
//
//  Created by Zian Chen on 11/26/24.
//

import AudioToolbox
import Dispatch
import SwiftUI

// Timer states
enum TimerState {
    case initial
    case running
    case paused
    case break_time
}

// Main timer view model
class PomodoroTimer: ObservableObject {
    @Published var timeRemaining: Int
    @Published var state: TimerState = .initial
    @Published var workDuration: Int = 25 * 60 // 25 minutes in seconds
    @Published var breakDuration: Int = 5 * 60 // 5 minutes in seconds
    private var timer: Timer?
    
    private var backgroundTimer: DispatchSourceTimer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    init() {
        self.state = .initial
        self.timeRemaining = 25 * 60
    }
    
    func startTimer() {
        requestNotificationPermission()
        state = .running
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Create a new timer
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        
        timer.setEventHandler { [weak self] in
            self?.updateTimer()
        }
        
        backgroundTimer = timer
        timer.resume()
        
        // Request background execution
        registerBackgroundTask()
    }
    
    func pauseTimer() {
        state = .paused
        UIApplication.shared.isIdleTimerDisabled = false
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        state = .initial
        UIApplication.shared.isIdleTimerDisabled = false
        timer?.invalidate()
        timer = nil
        timeRemaining = workDuration
    }
    
    private func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    var statusText: String {
        switch state {
        case .initial:
            return "Ready to start"
        case .running:
            return "Focus time"
        case .paused:
            return "Paused"
        case .break_time:
            return "Break time"
        }
    }
    
    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer?.invalidate()
            timer = nil
            
            if state == .running {
                // Work session completed
                sendNotification(title: "Work Session Complete!", body: "Time for a break!")
                playSound()
                state = .break_time
                timeRemaining = breakDuration
            } else if state == .break_time {
                // Break completed
                sendNotification(title: "Break Complete!", body: "Ready to start working?")
                playSound()
                state = .initial
                timeRemaining = workDuration
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func playSound() {
        AudioServicesPlaySystemSound(1005) // System sound
    }
}

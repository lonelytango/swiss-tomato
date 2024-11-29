//
//  SettingsView.swift
//  SwissTomato
//
//  Created by Zian Chen on 11/26/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var workDuration: Int
    @Binding var breakDuration: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Work Duration")) {
                    Picker("Minutes", selection: $workDuration) {
                        ForEach([15, 25, 30, 45, 60], id: \.self) { minutes in
                            Text("\(minutes) minutes")
                                .tag(minutes * 60)
                        }
                    }
                }

                Section(header: Text("Break Duration")) {
                    Picker("Minutes", selection: $breakDuration) {
                        ForEach([5, 10, 15, 20], id: \.self) { minutes in
                            Text("\(minutes) minutes")
                                .tag(minutes * 60)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

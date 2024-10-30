import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("autoBackup") private var autoBackup = false
    @AppStorage("darkMode") private var darkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Auto Backup", isOn: $autoBackup)
                    Toggle("Dark Mode", isOn: $darkMode)
                    Toggle("Notifications", isOn: $notificationsEnabled)
                }
                
                Section(header: Text("About")) {
                    HStack {  
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("2024.1")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        // Reset app logic here
                    } label: {
                        Text("Reset All Settings")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
import SwiftUI

struct SystemStatusView: View {
    @ObservedObject var systemMonitor: SystemMonitor
    
    var body: some View {
        VStack(spacing: 16) {
            Text("System Status")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    StatusRow(title: "iOS Version:", value: systemMonitor.status.deviceVersion)
                    StatusRow(title: "Storage:", value: systemMonitor.status.storageUsed)
                    StatusRow(title: "Battery:", value: "\(systemMonitor.status.batteryLevel)%")
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    StatusRow(title: "CPU Usage:", value: systemMonitor.status.cpuUsage)
                    StatusRow(title: "RAM:", value: systemMonitor.status.ramUsage)
                    StatusRow(title: "Network:", value: systemMonitor.status.networkType)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatusRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Text(value)
                .fontWeight(.medium)
        }
    }
}
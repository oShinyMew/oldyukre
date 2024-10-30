import Foundation

enum ToolCategory: String {
    case system = "System"
    case security = "Security"
    case network = "Network"
    case diagnostics = "Diagnostics"
    case tweaks = "Tweaks"
    case kernel = "Kernel"
}

struct Tool: Identifiable {
    let id: String
    let name: String
    let description: String
    let supportedVersions: [String]
    let category: ToolCategory
    var isEnabled: Bool
    let requiresRoot: Bool
    let impact: SecurityImpact
}

enum SecurityImpact: String {
    case low = "Low Risk"
    case medium = "Medium Risk"
    case high = "High Risk"
    case critical = "Critical"
}

struct SystemStatus {
    var deviceVersion: String
    var batteryLevel: Int
    var storageUsed: String
    var ramUsage: String
    var cpuUsage: String
    var networkType: String
    var jailbreakStatus: Bool
    var kernelVersion: String
    var securityLevel: SecurityLevel
}

enum SecurityLevel: String {
    case secure = "Secure"
    case compromised = "Compromised"
    case unknown = "Unknown"
}

class SystemMonitor: ObservableObject {
    @Published private(set) var status: SystemStatus
    private var timer: Timer?
    
    init() {
        self.status = SystemStatus(
            deviceVersion: UIDevice.current.systemVersion,
            batteryLevel: Int(UIDevice.current.batteryLevel * 100),
            storageUsed: Self.getStorageUsage(),
            ramUsage: Self.getRAMUsage(),
            cpuUsage: "32%",
            networkType: "Wi-Fi",
            jailbreakStatus: false,
            kernelVersion: "Darwin 22.3.0",
            securityLevel: .secure
        )
        startMonitoring()
    }
    
    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateStatus()
        }
    }
    
    private func updateStatus() {
        status.cpuUsage = "\(Int.random(in: 0...100))%"
        status.ramUsage = String(format: "%.1f GB / 4 GB", Double.random(in: 0...4))
        objectWillChange.send()
    }
    
    private static func getStorageUsage() -> String {
        let fileManager = FileManager.default
        if let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let attributes = try fileManager.attributesOfFileSystem(forPath: path.path)
                let total = attributes[.systemSize] as? Int64 ?? 0
                let free = attributes[.systemFreeSize] as? Int64 ?? 0
                let used = total - free
                return String(format: "%.1f GB / %.0f GB", 
                            Double(used) / 1_000_000_000,
                            Double(total) / 1_000_000_000)
            } catch {
                return "Unknown"
            }
        }
        return "Unknown"
    }
    
    private static func getRAMUsage() -> String {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMB = Double(info.resident_size) / 1024.0 / 1024.0
            return String(format: "%.1f GB / 4 GB", usedMB / 1024.0)
        }
        
        return "Unknown"
    }
}
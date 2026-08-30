import SwiftUI
import AppKit
import Combine
import Foundation

@MainActor
final class ThermalMonitor: ObservableObject {

    @Published private(set) var thermalState: ProcessInfo.ThermalState

    private var observer: NSObjectProtocol?

    init() {
        thermalState = ProcessInfo.processInfo.thermalState

        observer = NotificationCenter.default.addObserver(
            forName: ProcessInfo.thermalStateDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.refresh()
            }
        }
    }

    deinit {
        if let observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    func refresh() {
        thermalState = ProcessInfo.processInfo.thermalState
    }

    var status: String {
        switch thermalState {
        case .nominal:
            return "Normal"
        case .fair:
            return "Elevated"
        case .serious:
            return "High"
        case .critical:
            return "Critical"
        @unknown default:
            return "Unknown"
        }
    }

    var performance: String {
        switch thermalState {
        case .nominal:
            return "None"
        case .fair:
            return "Minimal"
        case .serious:
            return "Reduced"
        case .critical:
            return "Critical"
        @unknown default:
            return "Unknown"
        }
    }

    var symbolName: String {
        switch thermalState {
        case .nominal:
            return "circle.fill"
        case .fair:
            return "circle.lefthalf.filled"
        case .serious:
            return "exclamationmark.circle.fill"
        case .critical:
            return "exclamationmark.triangle.fill"
        @unknown default:
            return "questionmark.circle"
        }
    }
}

@main
struct MacThermalApp: App {

    @StateObject private var monitor = ThermalMonitor()

    var body: some Scene {

        MenuBarExtra {

            VStack(alignment: .leading, spacing: 12) {

                Text("MacThermal")
                    .font(.headline)

                Divider()

                HStack {
                    Text("Thermal State")

                    Spacer()

                    Text(monitor.status)
                        .fontWeight(.medium)
                }

                HStack {
                    Text("Performance Impact")

                    Spacer()

                    Text(monitor.performance)
                        .foregroundStyle(.secondary)
                }

                Divider()

                Button("Refresh") {
                    monitor.refresh()
                }

                Button("Quit MacThermal") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding()
            .frame(width: 260)

        } label: {

            HStack(spacing: 5) {
                Image(systemName: monitor.symbolName)

                Text(monitor.status)
            }
        }
        .menuBarExtraStyle(.window)
    }
}

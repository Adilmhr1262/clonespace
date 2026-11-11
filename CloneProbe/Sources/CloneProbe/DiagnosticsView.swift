import SwiftUI
import UIKit

struct DiagnosticsView: View {
    @ObservedObject var store: ProbeStore

    private var bundle: Bundle { Bundle.main }

    private var rows: [(String, String)] {
        let fm = FileManager.default
        let home = NSHomeDirectory()
        let docs = ProbeStore.documentsURL.path
        let library = fm.urls(for: .libraryDirectory, in: .userDomainMask).first?.path ?? "-"
        let caches = fm.urls(for: .cachesDirectory, in: .userDomainMask).first?.path ?? "-"
        let tmp = NSTemporaryDirectory()
        return [
            ("Bundle identifier", bundle.bundleIdentifier ?? "-"),
            ("App name", bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "-"),
            ("Version", bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"),
            ("Build", bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "-"),
            ("Executable", bundle.executablePath ?? "-"),
            ("Bundle path", bundle.bundlePath),
            ("Home", home),
            ("Documents", docs),
            ("Library", library),
            ("Caches", caches),
            ("Temporary", tmp),
            ("State file", ProbeStore.stateFileURL.path),
            ("State file exists", store.stateFileExists ? "yes" : "no"),
            ("Device", UIDevice.current.model),
            ("System", "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"),
            ("Identifier for vendor", UIDevice.current.identifierForVendor?.uuidString ?? "-"),
        ]
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Bundle") {
                    ForEach(rows.prefix(6), id: \.0) { row in
                        DiagnosticRow(label: row.0, value: row.1)
                    }
                }
                Section("Storage paths") {
                    ForEach(Array(rows[6..<14]), id: \.0) { row in
                        DiagnosticRow(label: row.0, value: row.1)
                    }
                }
                Section("Device") {
                    ForEach(Array(rows[14...]), id: \.0) { row in
                        DiagnosticRow(label: row.0, value: row.1)
                    }
                }
                Section("Stored state (JSON)") {
                    Text(store.stateJSONText)
                        .font(.system(.caption, design: .monospaced))
                        .textSelection(.enabled)
                }
            }
            .navigationTitle("Diagnostics")
            .refreshable {
                await MainActor.run { store.load() }
            }
        }
    }
}

struct DiagnosticRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(.body, design: .monospaced))
                .textSelection(.enabled)
        }
        .padding(.vertical, 2)
    }
}

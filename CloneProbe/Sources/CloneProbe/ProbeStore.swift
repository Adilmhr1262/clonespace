import Foundation

/// Persistent state for CloneProbe. Stored as a single JSON file inside the
/// app's Documents folder so LiveContainer's per-profile data folders keep
/// Profile A and Profile B apart. Nothing is stored in the keychain or in
/// any shared location.
struct ProbeState: Codable {
    var counter: Int = 0
    var note: String = ""
    var profileName: String = "Profile"
    var launchCount: Int = 0
}

@MainActor
final class ProbeStore: ObservableObject {
    @Published var state = ProbeState()

    static let fileName = "CloneProbeState.json"

    static var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static var stateFileURL: URL {
        documentsURL.appendingPathComponent(fileName)
    }

    init() {
        load()
        state.launchCount += 1
        save()
    }

    func load() {
        let url = Self.stateFileURL
        guard let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(ProbeState.self, from: data) else {
            return
        }
        state = decoded
    }

    func save() {
        let url = Self.stateFileURL
        try? FileManager.default.createDirectory(
            at: Self.documentsURL, withIntermediateDirectories: true)
        guard let data = try? JSONEncoder().encode(state) else { return }
        try? data.write(to: url, options: [.atomic])
    }

    func increment(by amount: Int = 1) {
        state.counter += amount
        save()
    }

    func resetCounterAndNote() {
        state.counter = 0
        state.note = ""
        save()
    }

    var stateFileExists: Bool {
        FileManager.default.fileExists(atPath: Self.stateFileURL.path)
    }

    var stateJSONText: String {
        guard let data = try? JSONEncoder().encode(state),
              let text = String(data: data, encoding: .utf8) else {
            return "(could not encode state)"
        }
        return text
    }
}

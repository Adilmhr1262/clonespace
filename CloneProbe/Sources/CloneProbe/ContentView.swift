import SwiftUI

struct ContentView: View {
    @StateObject private var store = ProbeStore()

    var body: some View {
        TabView {
            ProbeView(store: store)
                .tabItem {
                    Label("Probe", systemImage: "flask")
                }
            DiagnosticsView(store: store)
                .tabItem {
                    Label("Diagnostics", systemImage: "info.circle")
                }
        }
    }
}

struct ProbeView: View {
    @ObservedObject var store: ProbeStore
    @State private var showingResetConfirm = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Profile name", text: $store.state.profileName)
                        .autocorrectionDisabled()
                        .onChange(of: store.state.profileName) { _, _ in store.save() }
                    HStack {
                        Text("Launches")
                        Spacer()
                        Text("\(store.state.launchCount)")
                            .font(.headline)
                            .monospacedDigit()
                    }
                }

                Section("Counter") {
                    Text("\(store.state.counter)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Button("-1") { store.increment(by: -1) }
                            .buttonStyle(.bordered)
                        Spacer()
                        Button("+1") { store.increment(by: 1) }
                            .buttonStyle(.borderedProminent)
                        Spacer()
                        Button("+5") { store.increment(by: 5) }
                            .buttonStyle(.bordered)
                    }
                }

                Section("Note") {
                    TextField("Profile-specific note", text: $store.state.note, axis: .vertical)
                        .lineLimit(3...)
                        .onChange(of: store.state.note) { _, _ in store.save() }
                }

                Section {
                    Button("Reset counter and note", role: .destructive) {
                        showingResetConfirm = true
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                } footer: {
                    Text("Reset sets the counter to 0 and clears the note. Profile name and launch count are kept.")
                }
            }
            .navigationTitle(store.state.profileName.isEmpty ? "CloneProbe" : store.state.profileName)
            .alert("Reset counter and note?", isPresented: $showingResetConfirm) {
                Button("Reset", role: .destructive) { store.resetCounterAndNote() }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

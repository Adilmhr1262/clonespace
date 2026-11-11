# CloneSpace

No-jailbreak iPhone app cloner based on LiveContainer, for iPhone 16 Pro Max.
LiveContainer 3.8.0 is the guest runtime; CloneSpace is the SwiftUI
management interface being built around it.

## Status (2026-11-11)
- M1 environment report: done (see `clonespace-m1-report.md` in the agent workspace)
- M3/M4: LiveContainer 3.8.0 installed on the iPhone via AltStore,
  certificate imported, JIT-less diagnose shows valid.
- M5: CloneProbe (first test app) source is in `CloneProbe/`. It is built
  by GitHub Actions (`.github/workflows/build-cloneprobe.yml`) because
  the Mac has no Xcode; see `CLOUD-BUILD.md`.

## CloneProbe
A small SwiftUI test app that proves separate LiveContainer guest profiles
keep separate data: persistent counter, profile note, profile name, launch
count, reset button, diagnostics screen. See `CloneProbe/README.md` for
the M6 isolation test.

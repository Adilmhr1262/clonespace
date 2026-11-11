# CloneProbe

First test app for CloneSpace / LiveContainer. A small SwiftUI app that proves
separate LiveContainer guest profiles keep separate data.

## What it does
- Persistent counter (+1 / -1 / +5), stored in `Documents/CloneProbeState.json`
- Profile-specific note (text field, same file)
- Locally stored profile name (same file)
- Visible launch count (increments on every launch, same file)
- Reset button (counter to 0, note cleared; profile name and launch count kept)
- Diagnostics tab: bundle ID, version, build, executable/bundle paths,
  home/Documents/Library/Caches/tmp paths, state file path and contents,
  device model, iOS version, identifier for vendor

## Why a file, not UserDefaults
State lives in one JSON file in Documents. LiveContainer redirects each
profile to its own data folder, so Profile A and Profile B get different
files and cannot see each other's counter or note.

## Isolation test (M6)
1. In LiveContainer, import CloneProbe.ipa and create Profile A.
   Set counter to 15, note "Account A", profile name "Profile A".
2. Create Profile B. Set counter to 3, note "Account B", profile name "Profile B".
3. Switch between profiles, force-close LiveContainer, reopen, verify both
   values are unchanged.
4. Delete Profile A. Confirm Profile B still shows counter 3 / "Account B".

## Build
Preferred (no Xcode on the Mac, so currently blocked): `xtool dev build`
in this directory. Requires the Darwin Swift SDK (`xtool sdk status` must
not say "Not installed"), which needs Xcode.xip / Xcode.app or
`xtool auth`. See `~/workspace/clonespace-m1-report.md`.

Fallback: GitHub Actions cloud build (see `../../clonespace-github-actions.md`
in the workspace, and `.github/workflows/build-cloneprobe.yml` once pushed).
The macOS runner has Xcode; it builds the SwiftPM package, signs the IPA
with a free Apple ID via AltStore-compatible signing is NOT done by the
runner — the IPA it produces is unsigned and must be installed through
AltStore on the iPhone, which re-signs it with the user's free certificate.

## Install on iPhone
1. Copy CloneProbe.ipa to iCloud Drive.
2. On the iPhone, AltStore > My Apps > + > pick CloneProbe.ipa.
3. Open LiveContainer > import CloneProbe.ipa as a guest app.

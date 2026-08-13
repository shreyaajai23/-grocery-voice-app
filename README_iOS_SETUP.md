# Getting this app onto your iPhone (free, no Mac required)

This machine (Windows) can't compile an iOS app — that always requires Xcode on
macOS, no matter what framework you use. Since this app is just for the two of
you (not App Store distribution) and you don't want to pay for the $99/yr Apple
Developer Program, here's the free path using **Codemagic** (a CI service with
a free tier that includes macOS build machines) plus your existing free Apple ID.

## What this gets you

A real .ipa file, built in the cloud, installed straight to your iPhone. The
catch with a *free* Apple ID (as opposed to a paid Developer Program
membership): apps you sideload this way **expire after 7 days** and need to be
reinstalled. There's no way around that without paying Apple — it's an Apple
policy on personal-team code signing, not something Codemagic or I can bypass.
If that becomes annoying, enrolling in the $99/yr Apple Developer Program
removes the 7-day limit (via TestFlight) — your call, not required to get
started.

## One-time setup

1. **Push this project to a Git repository** (GitHub, GitLab, or Bitbucket).
   Codemagic builds from a repo, not a local folder.
   ```
   cd C:\Users\shrey\Projects\grocery_voice_app
   git init
   git add .
   git commit -m "Initial commit"
   ```
   Then create an empty repo on GitHub and push to it.

2. **Sign up at [codemagic.io](https://codemagic.io)** with the same GitHub
   account (free tier: 500 build minutes/month, no credit card required).

3. **Add your app** in the Codemagic dashboard — select the repo you just
   pushed. Codemagic auto-detects it's a Flutter project.

4. **Set up iOS code signing with your free Apple ID:**
   - In the Codemagic app settings, go to iOS code signing.
   - Choose "Automatic" signing and sign in with your Apple ID when prompted
     (this happens in Codemagic's UI, using your own Apple ID login — I'm not
     involved in this step, it's between you and Apple/Codemagic).
   - Register your iPhone's UDID (Codemagic's docs show how to find this, or
     you can get it from Xcode/Finder if you ever have access to a Mac, or
     via a UDID-lookup site — search "how to find iPhone UDID without Mac").
   - Select "Development" (not App Store/TestFlight) distribution.

5. **Start a build.** Codemagic will run `flutter build ipa` on a macOS
   runner and produce a signed .ipa for your device.

6. **Install to your iPhone** — Codemagic can give you a QR code / OTA install
   link for development builds, or you can download the .ipa and install it
   via [AltStore](https://altstore.io) (free, runs on Windows, also handles
   the weekly re-signing automatically if you keep AltServer running on this
   PC and your phone on the same WiFi periodically).

## Re-signing (every ~7 days)

With a free Apple ID, the app's signature expires weekly. Two ways to handle it:
- **Manual**: re-run the Codemagic build and reinstall the .ipa.
- **Automatic**: use AltStore/AltServer, which refreshes the signature
  automatically as long as AltServer runs on a computer on the same network
  as your phone every so often.

## If you'd rather skip all this

Android development works fully on this machine right now — no CI, no
expiring signatures. If the 7-day iOS re-sign cycle turns out to be more
hassle than it's worth, the app runs the same on an Android phone with zero
extra setup.

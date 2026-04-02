# Alche — Publishing & Update Guide

Quick reference for TestFlight builds and App Store submissions.

---

## App Identity

| Field | Value |
|-------|-------|
| Bundle ID | `com.alche.app` |
| Display Name | `alche` |
| Team ID | `B5N883S37V` |
| SKU | `alche-ios-v1` |
| Signing | Automatic |
| Backend | Supabase (EU Frankfurt) |
| Encryption | Standard HTTPS only (`ITSAppUsesNonExemptEncryption = false`) |

---

## Push a New TestFlight Build

### 1. Bump version numbers

In `app/project.yml`:
```yaml
MARKETING_VERSION: "1.1.0"    # public version (semver)
CURRENT_PROJECT_VERSION: 2     # must increment every upload
```

Then regenerate:
```bash
cd /Users/timoel/Desktop/alche/app
xcodegen generate
```

### 2. Build & verify

```bash
xcodebuild -scheme Alche -destination 'generic/platform=iOS' -configuration Release build 2>&1 | tail -20
```

Must show `BUILD SUCCEEDED` with 0 errors.

### 3. Archive

1. Open `app/Alche.xcodeproj` in Xcode
2. Top bar: select **Any iOS Device (arm64)** (NOT a simulator — Archive is greyed out on simulators)
3. Product -> Archive
4. Wait 3-5 minutes

### 4. Upload

1. Organizer opens automatically
2. Select the archive -> **Distribute App**
3. Choose **TestFlight Internal Only** (or App Store Connect for external)
4. Let Xcode upload (5-10 min)
5. Both checkmarks green = success

### 5. Wait for processing

- Apple processes the build: 5-30 minutes
- You get an email when done (or if issues found)
- Check: App Store Connect -> My Apps -> alche -> **TestFlight tab**
- Build status changes from "Processing" to "Ready to Test"

### 6. Notify testers

- TestFlight tab -> Internal Testing -> your group
- New builds auto-distribute to existing testers if "Automatic Distribution" is on
- New testers: add them to the group -> they get an invite email -> must accept -> open TestFlight app -> install

---

## Add a New Tester

### Internal (team members, max 100, no Apple review)

1. App Store Connect -> Users and Access -> + -> enter their Apple ID email
2. Assign role: Developer, Marketing, or App Manager
3. They accept the team invite email
4. TestFlight tab -> Internal Testing -> group -> + Add Testers -> select them
5. They receive a TestFlight invite email
6. They open email on iPhone -> tap "View in TestFlight" -> accept -> install
7. They need the free TestFlight app from the App Store

### External (anyone, max 10,000, requires Beta App Review)

1. TestFlight tab -> External Testing -> + Create Group
2. Add testers by email OR enable Public Link
3. Add a build to the group
4. First build triggers Beta App Review (24-48 hours)
5. After approval, testers get invites automatically

---

## Submit to App Store (when ready)

### Required metadata (fill in App Store tab)

| Field | Value |
|-------|-------|
| Description | See below |
| Keywords | `longevity,wellness,skin,glow,biomarkers,smoothie,LED,booking,health,lifestyle` |
| Support URL | `https://timurael.github.io/alche_app/docs/privacy-policy.html` |
| Privacy Policy URL | `https://timurael.github.io/alche_app/docs/privacy-policy.html` |
| Primary Category | Health & Fitness |
| Secondary Category | Lifestyle |
| Price | Free (Tier 0) |
| Age Rating | 4+ (answer No to all content questions) |
| Content Rights | No third-party content |

### Description

```
Your longevity lifestyle, in one place.

alche is the operating system for modern wellness. Book LED therapy sessions, order functional smoothies, browse curated longevity products, and follow daily protocols — all from your phone.

What you get:
- Book LED light therapy and wellness practitioner sessions
- Order functional smoothies and check in with your membership QR
- Browse curated longevity products
- Follow personalized daily wellness protocols
- Track your progress with streaks and trend charts
- Explore Glow Scan, Biomarker Dashboard, and Digital Twin (preview)
- Discover wellness content and partner restaurants
- Track macros when eating out at partner spots

Built for the alche space in Berlin. Designed for people who take living well seriously — without the clinical vibe.
```

### App Review Information

| Field | Value |
|-------|-------|
| Contact | Timur [last name], [email], [phone] |
| Demo Account | Provide working login credentials |
| Notes for Reviewer | See below |

### Review Notes

```
alche is the companion app for a longevity lifestyle space in Berlin.

Key context for review:
- Glow Scan, Biomarker Dashboard, and Digital Twin are vision features with mock/sample data, clearly labeled with "Sample Data" indicators throughout. These features preview upcoming functionality.
- Booking and smoothie ordering require the physical Berlin location.
- All health language uses "supports" and "helps" — never "treats" or "cures."
- Sessions with wellness practitioners include a disclaimer: "Sessions are for wellness guidance and lifestyle optimization. They do not constitute medical advice, diagnosis, or treatment."
- The app is GDPR-compliant (EU user base, Supabase backend in EU Frankfurt).
```

### Screenshots needed

| Device | Size (portrait) |
|--------|----------------|
| iPhone 6.7" (required) | 1290 x 2796 px |
| iPhone 6.9" (recommended) | 1320 x 2868 px |
| iPad 13" (required if Universal) | 2064 x 2752 px |

### Pre-submission checklist

- [ ] PLA signed (App Store Connect -> Business -> Agreements)
- [ ] Tax and banking completed (if selling IAP/subscriptions)
- [ ] Privacy labels completed (App Privacy section)
- [ ] Age rating questionnaire answered
- [ ] Account deletion flow implemented
- [ ] Restore Purchases button present (if IAP exists)
- [ ] All mock data screens show DataSourceIndicator
- [ ] No "treats" / "cures" / "heals" language anywhere
- [ ] Demo account credentials ready
- [ ] Screenshots uploaded for all required sizes
- [ ] Privacy policy URL is live and accessible

---

## Key Files

| File | Purpose |
|------|---------|
| `app/project.yml` | XcodeGen config (version, signing, Info.plist properties) |
| `app/Alche/Info.plist` | Generated by xcodegen — don't edit directly |
| `app/Alche/PrivacyInfo.xcprivacy` | Apple privacy manifest |
| `app/ExportOptions.plist` | CLI archive export config |
| `app/Alche/Assets.xcassets/AppIcon.appiconset/` | App icon (1024x1024) |
| `docs/privacy-policy.html` | Privacy policy (GitHub Pages) |

---

## Common Issues

| Problem | Fix |
|---------|-----|
| Archive greyed out | Select "Any iOS Device" not a simulator |
| "Missing Compliance" on build | Already handled — `ITSAppUsesNonExemptEncryption = false` in Info.plist |
| Tester can't see build | Check their Apple ID matches invite email. Check spam. Resend invite. |
| Signing error after PLA update | App Store Connect -> Business -> Agreements -> accept new PLA |
| Build number already used | Increment `CURRENT_PROJECT_VERSION` in project.yml, regenerate |
| Upload fails | Check Xcode -> Settings -> Accounts -> verify Apple ID is added |

---

## GitHub

- Repo: https://github.com/timurael/alche_app
- Privacy policy: https://timurael.github.io/alche_app/docs/privacy-policy.html
- GitHub Pages: Settings -> Pages -> Source: main branch, /docs folder

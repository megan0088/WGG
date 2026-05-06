# WGG Watch App — Dokumentasi Teknis
> Panduan lengkap arsitektur dan alur kode Watch app (watchOS).

---

## Daftar Isi
1. [Gambaran Besar](#1-gambaran-besar)
2. [Alur Layar](#2-alur-layar)
3. [Arsitektur & File Penting](#3-arsitektur--file-penting)
4. [Konsep Swift/SwiftUI yang Dipakai](#4-konsep-swiftswiftui)
5. [WatchConnectivity — Watch ke iPhone](#5-watchconnectivity--watch-ke-iphone)
6. [Fitur-fitur Teknis](#6-fitur-fitur-teknis)
7. [Troubleshooting & Catatan Penting](#7-troubleshooting--catatan-penting)
8. [Glossary](#8-glossary)

---

## 1. Gambaran Besar

App WGG terdiri dari dua target dalam satu proyek Xcode:

| Target | Platform | Bundle ID |
|--------|----------|-----------|
| `WGG` | iOS (iPhone) | `com.eganugraha.WGG` |
| `WGG Watch App` | watchOS (Apple Watch) | `com.eganugraha.WGG.watchkitapp` |

```
Apple Watch                         iPhone
┌──────────────────────┐            ┌──────────────────────┐
│   WGG Watch App      │            │      WGG (iOS)       │
│                      │            │                      │
│  • Pilih rutinitas   │  ────────▶ │  • Terima data       │
│  • Catat set & reps  │ WatchConn. │  • Simpan SwiftData  │
│  • Timer set & rest  │            │  • Tampilkan di      │
│  • Kirim ke iPhone   │            │    Dashboard         │
└──────────────────────┘            └──────────────────────┘
```

**Aturan bundle ID (penting!):**
- Bundle ID Watch app HARUS diawali dengan bundle ID iOS + suffix apapun (e.g. `.watchkitapp`)
- `INFOPLIST_KEY_WKCompanionAppBundleIdentifier` di Build Settings Watch target HARUS sama persis dengan bundle ID iOS

---

## 2. Alur Layar

### Navigasi Utama

Navigasi dikontrol oleh `WatchSessionManager.isWorkoutActive`:

```
WatchContentView
├── isWorkoutActive = false  →  WatchHomeView
└── isWorkoutActive = true   →  WatchWorkoutView (root workout stack)
```

### Alur Lengkap Workout

```
WatchHomeView
  [Tap Play]  →  sessionManager.isWorkoutActive = true
                      │
                      ▼
              WatchWorkoutView       ← Daftar rutinitas (Pull Day, Push Day, dll)
                      │
                      ▼
          WatchExercisePickerView    ← Pilih exercise dari rutinitas
                      │
                      ▼
           WatchWeightInputView      ← Input berat (kg) via Digital Crown
                      │
                      ▼
            WatchCountdownView       ← Hitung mundur 3-2-1 sebelum mulai
                      │
                      ▼
            WatchActiveSetView       ← Counter reps real-time + timer set berjalan
                      │ [Tekan ✓]
                      ▼
             WatchSetDoneView        ← Konfirmasi reps & berat, bisa edit manual
                      │ [Log]
                      ▼
           WatchRestTimerView        ← Timer istirahat 60 detik
                      │
               ┌──────┼──────┐
          [Next Set]  │  [Next Ex.]  [Finish]
               │      │           │
               ▼      │           ▼
       WatchActiveSetView  WatchExercisePickerView  WatchSummaryView
       (set berikutnya)    (ganti exercise)               │
                                               [Send to iPhone] [Back to Home]
                                                               │
                                               sessionManager.reset()
                                               isWorkoutActive = false
                                                               │
                                                        WatchHomeView
```

---

## 3. Arsitektur & File Penting

### Entry Point

**`WGG_Watch_AppApp.swift`**
```swift
@main
struct WGGWatchApp: App {
    @State private var sessionManager = WatchSessionManager()

    var body: some Scene {
        WindowGroup {
            WatchContentView()
                .environment(sessionManager)   // inject ke semua view
                .onAppear { sessionManager.activate() }  // aktifkan WatchConnectivity
        }
    }
}
```

### Controller Navigasi

**`WatchContentView.swift`**

Memutuskan tampilan berdasarkan `sessionManager.isWorkoutActive`:
```swift
if sessionManager.isWorkoutActive {
    NavigationStack { WatchWorkoutView() }
} else {
    NavigationStack { WatchHomeView() }
}
```

Ini menggantikan pola navigate-back yang rumit: ketika workout selesai, cukup set `isWorkoutActive = false` dan SwiftUI otomatis kembali ke home.

### Model Data

**`WatchWorkoutModels.swift`**

```swift
struct WatchExercise      // Satu exercise: nama, muscle group, target berat & reps
struct WatchRoutine       // Kumpulan exercise dalam satu sesi (Pull Day, Push Day, dll)
struct WatchLoggedSet     // Satu set selesai: reps, berat, setDuration, restDuration
struct WatchLoggedExercise // Satu exercise + semua set-nya yang sudah dicatat
```

Rutinitas yang tersedia (harus sama dengan iOS `MockDataSeeder`):

| Rutinitas | Exercise |
|-----------|----------|
| Pull Day | Pull Up, Bent Over Row, Lat Pulldown, Dumbbell Row |
| Push Day | Bench Press, Incline Dumbbell Press, Dumbbell Fly, Overhead Press, Lateral Raises |
| Leg Day | Squat, Leg Press, Leg Curl, Leg Extension |
| Arm Day | Barbell Curl, Dumbbell Curl, Dumbbell Bicep Curl |

> **Penting:** Nama exercise dan muscle group HARUS sama persis dengan iOS, karena `PhoneSessionManager` mencari exercise di database iPhone menggunakan nama.

### Otak Sesi

**`WatchSessionManager.swift`**

Kelas `@Observable` yang diakses oleh semua view via `@Environment`. Fungsinya:

| Properti / Fungsi | Kegunaan |
|-------------------|----------|
| `isWorkoutActive` | `true` saat workout berlangsung, `false` di home |
| `loggedExercises` | Kumpulan semua exercise + set yang sudah dicatat |
| `sendStatus` | Status pengiriman ke iPhone (idle/sending/sent/queued/failed) |
| `logSet(exercise:weight:reps:setDuration:)` | Catat satu set selesai |
| `updateLastRestDuration(_:)` | Update durasi istirahat set terakhir |
| `sendToPhone()` | Kirim semua data ke iPhone via WatchConnectivity |
| `reset()` | Hapus semua data, kembali ke home (`isWorkoutActive = false`) |

### Views

| File | Fungsi |
|------|--------|
| `WatchHomeView` | Layar awal: tombol Play untuk mulai workout |
| `WatchWorkoutView` | Daftar rutinitas |
| `WatchExercisePickerView` | Pilih exercise dari rutinitas yang dipilih |
| `WatchWeightInputView` | Input berat dengan Digital Crown & tombol +/- |
| `WatchCountdownView` | Countdown 3-2-1 sebelum set dimulai |
| `WatchActiveSetView` | Counter reps real-time + timer set berjalan |
| `WatchSetDoneView` | Konfirmasi reps & berat, edit manual dengan +/- |
| `WatchRestTimerView` | Timer istirahat dengan overtime merah + haptics |
| `WatchSummaryView` | Ringkasan workout, kirim ke iPhone, kembali ke home |
| `WatchDetectionView` | (Opsional) Preview deteksi gerakan |

---

## 4. Konsep Swift/SwiftUI

### `@Observable` + `@Environment`

`WatchSessionManager` diberi anotasi `@Observable` dan di-inject sekali di entry point:
```swift
// Di App entry point — inject sekali
WatchContentView().environment(sessionManager)

// Di view manapun — ambil referensinya
@Environment(WatchSessionManager.self) private var sessionManager
```

Karena ini class (reference type), memodifikasi `sessionManager.isWorkoutActive = true` di dalam sebuah view langsung terasa oleh semua view lain yang mengobserve properti itu.

### Navigasi dengan `navigationDestination(isPresented:)`

Setiap view yang push ke view berikutnya menggunakan pola:
```swift
@State private var goToNext = false

Button("Lanjut") { goToNext = true }

.navigationDestination(isPresented: $goToNext) {
    ViewBerikutnya(...)
}
```

> **Catatan:** Tidak perlu `NavigationLink`. Pola ini memisahkan aksi dari navigasi, sehingga bisa trigger navigasi dari mana saja (tombol, timer, dsb).

### `@FocusState` + `digitalCrownRotation` (Digital Crown)

Di `WatchWeightInputView`:
```swift
@FocusState private var crownFocused: Bool
@State private var weight: Double = 20.0

Text("\(weight, specifier: "%.1f") kg")
    .focused($crownFocused)
    .digitalCrownRotation($weight, from: 0, through: 300, by: 2.5, sensitivity: .medium)
    .onAppear { crownFocused = true }
```

### Timer

Dua jenis timer dipakai:

**Elapsed timer** (WatchActiveSetView — hitung berapa lama set berlangsung):
```swift
let setTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
@State private var elapsedSeconds = 0
.onReceive(setTimer) { _ in elapsedSeconds += 1 }
```

**Countdown timer** (WatchRestTimerView — presisi 0.05s untuk animasi halus):
```swift
let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
@State private var timeRemaining: Double = 60
.onReceive(timer) { _ in timeRemaining -= 0.05 }
```

### Haptics (WatchKit)

Di `WatchRestTimerView`, saat waktu istirahat habis:
```swift
import WatchKit
WKInterfaceDevice.current().play(.notification)
```

---

## 5. WatchConnectivity — Watch ke iPhone

### Cara Kerja

WatchConnectivity punya dua metode pengiriman:

| Metode | Kondisi | Waktu terima |
|--------|---------|-------------|
| `sendMessage` | iPhone app sedang terbuka (foreground) | Instan |
| `transferUserInfo` | iPhone app tertutup / background | Saat app dibuka berikutnya |

`WatchSessionManager.sendToPhone()` mencoba `sendMessage` dulu, fallback ke `transferUserInfo`:
```swift
if WCSession.default.isReachable {
    WCSession.default.sendMessage(payload, replyHandler: nil) { error in
        WCSession.default.transferUserInfo(payload)  // fallback
    }
    sendStatus = .sent
} else {
    WCSession.default.transferUserInfo(payload)      // antri
    sendStatus = .queued
}
```

### Format Payload

```
{
  "exercises": [
    {
      "name": "Pull Up",
      "muscleGroup": "Back",
      "sets": [
        {
          "setNumber": 1,
          "reps": 8,
          "weight": 0.0,
          "setDuration": 45.0,   ← detik mengerjakan set
          "restDuration": 62.3   ← detik istirahat setelahnya
        }
      ]
    }
  ]
}
```

### Di iPhone (`PhoneSessionManager.swift`)

Menerima dari dua sumber:
```swift
// iPhone app terbuka
func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
    handleReceivedWorkout(message)
}

// iPhone app tertutup saat Watch mengirim
func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
    handleReceivedWorkout(userInfo)
}
```

Data disimpan sebagai `Session → SessionExercise → SessionSet` di SwiftData.

### Kenapa `setDuration` & `restDuration` penting?

iOS Dashboard menghitung `totalMinutes` dari jumlah `setDuration + restDuration` per set. Tanpa data ini, kartu "Minutes" di dashboard akan selalu 0.

---

## 6. Fitur-fitur Teknis

### Set Duration Timer

Di `WatchActiveSetView`, timer berjalan otomatis saat set dimulai:
```swift
@State private var elapsedSeconds = 0
let setTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

// Tampilkan di UI
Text(timeString)  // format "1:23"

// Kirim ke WatchSetDoneView saat konfirmasi
WatchSetDoneView(..., setDuration: Double(elapsedSeconds))
```

### Rest Overtime

Di `WatchRestTimerView`, saat `timeRemaining < 0`:
1. Ring berubah merah dan berkedip
2. Timer terus bertambah (negative)
3. Haptic notification berbunyi sekali
4. Tidak ada auto-navigasi — user yang memutuskan kapan lanjut

```swift
if timeRemaining < 0 && !isBlinking {
    WKInterfaceDevice.current().play(.notification)
    withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
        isBlinking = true
    }
}
```

### Edit Manual di Set Done

Di `WatchSetDoneView`, tombol "Edit" membuka mode edit dengan +/- untuk:
- Reps (step 1, min 1, max 50)
- Weight (step 2.5 kg, min 0, max 300)

### Send Status

`WatchSessionManager.sendStatus` punya 5 state:

| State | Artinya | UI |
|-------|---------|-----|
| `.idle` | Belum dikirim | Tombol "Send to iPhone" aktif |
| `.sending` | Sedang mengirim | Tombol disabled, ikon spinning |
| `.sent` | Terkirim langsung | Tombol "Sent!" (hijau, disabled) |
| `.queued` | Antri (iPhone tidak terbuka) | Tombol "Queued" + pesan info |
| `.failed` | Gagal | Tombol "Retry" (merah) |

---

## 7. Troubleshooting & Catatan Penting

### Device Install Error: Bundle ID Mismatch

**Error:** `WKCompanionAppBundleIdentifier = com.xxx` tidak cocok dengan iOS bundle ID.

**Fix:** Di Xcode, pilih Watch target → Build Settings → cari `WKCompanion` → ubah nilainya ke bundle ID iOS yang benar (`com.eganugraha.WGG`).

### Data Tidak Masuk ke iPhone

**Kemungkinan 1:** `transferUserInfo` sudah antri tapi `PhoneSessionManager` tidak mengimplementasikan `didReceiveUserInfo`. ✅ Sudah diperbaiki — kedua metode delegate ada.

**Kemungkinan 2:** `modelContext` belum di-configure. Pastikan `PhoneSessionManager.configure(with:)` dipanggil di `WGGApp.onAppear`.

**Kemungkinan 3:** Nama exercise Watch berbeda dengan yang ada di database iPhone. Nama harus sama persis (case-sensitive) karena kode fetch menggunakan `#Predicate { $0.name == name }`.

### Navigasi Tersangkut / Tidak Bisa Kembali ke Home

Karena navigasi dikontrol oleh `isWorkoutActive`, jika stuck di tengah workout, cukup panggil `sessionManager.reset()`. Ini otomatis mengembalikan ke home karena `WatchContentView` mengobserve properti itu.

### Preview Crash di ViewBuilder

`#Preview` menggunakan `@ViewBuilder`. Tidak boleh ada `return` eksplisit atau statement void di top level. Gunakan immediately-invoked closure:
```swift
#Preview {
    let m = WatchSessionManager()
    m.logSet(...)
    return SomeView().environment(m)  // ← return HARUS di dalam closure ini
}
```

---

## 8. Glossary

| Istilah | Artinya |
|---------|---------|
| `@Observable` | Macro agar class bisa dipantau SwiftUI — kalau propertinya berubah, view yang menggunakannya otomatis re-render |
| `@Environment` | Cara mengakses objek yang di-inject dari parent view tanpa passing manual |
| `@State` | Variabel lokal milik sebuah view |
| `@FocusState` | Kontrol fokus input — dipakai untuk menghubungkan Digital Crown |
| `NavigationStack` | Container navigasi — push/pop view seperti tumpukan kartu |
| `navigationDestination(isPresented:)` | Trigger navigasi push dari boolean state |
| `WCSession` | WatchConnectivity Session — jembatan data antara Watch dan iPhone |
| `sendMessage` | Kirim data instan (butuh iPhone app terbuka) |
| `transferUserInfo` | Kirim data antri (otomatis dikirim saat iPhone app dibuka) |
| `SwiftData` | Framework database Apple modern yang dipakai di iOS untuk menyimpan sesi workout |
| `@Bindable` | Wrapper untuk `@Observable` class agar bisa dipakai sebagai `$binding` di SwiftUI |
| Mock data | Data dummy untuk preview/testing, bukan dari database nyata |
| Overtime | Kondisi saat timer rest sudah 0 tapi user belum lanjut |

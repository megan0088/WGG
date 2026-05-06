# Learning Notes — WGG Project
> Apa yang dipelajari dari membangun iOS + watchOS app dengan SwiftUI dan algoritma sensor.

---

## 1. SwiftUI — Konsep yang Dipraktikkan

### Reactive State (Data yang "Hidup")

Masalah utama di UI: bagaimana tampilan tahu kalau data berubah?

SwiftUI menjawabnya dengan sistem reaktif:

```swift
// Deklarasikan class sebagai "bisa dipantau"
@Observable
class WatchSessionManager {
    var repCount: Int = 0  // ← kalau ini berubah, view otomatis update
}

// Di view, ambil referensinya
@Environment(WatchSessionManager.self) private var manager
// Sekarang manager.repCount berubah → tampilan ikut berubah sendiri
```

**Yang dipelajari:** Data dan tampilan harus selalu sinkron. Di SwiftUI, kamu tidak perlu "update UI secara manual" — cukup update datanya, UI mengikuti.

---

### Data Flow — Satu Arah

```
Model (WatchSessionManager)
    │
    │  hanya baca
    ▼
View (WatchActiveSetView)
    │
    │  trigger aksi (tap tombol)
    ▼
Model berubah → View otomatis re-render
```

**Aturan:** View tidak boleh menyimpan logika bisnis. View hanya:
1. Menampilkan data dari model
2. Memanggil fungsi di model saat user berinteraksi

**Kenapa penting:** Kalau logic tersebar di mana-mana, bug susah ditemukan. Kalau logic terpusat di model, mudah di-test dan di-debug.

---

### Navigation Architecture

Dua pola navigasi yang dipakai:

**Pola 1 — Boolean trigger (dipakai di semua workout views)**
```swift
@State private var goToNext = false

Button("Lanjut") { goToNext = true }

.navigationDestination(isPresented: $goToNext) {
    ViewBerikutnya()
}
```

**Pola 2 — State di shared model (untuk kembali ke root)**
```swift
// Di WatchSessionManager:
var isWorkoutActive: Bool = false

// Di WatchContentView:
if sessionManager.isWorkoutActive {
    NavigationStack { WatchWorkoutView() }
} else {
    NavigationStack { WatchHomeView() }
}

// Di WatchSummaryView — untuk kembali ke home:
sessionManager.reset()  // set isWorkoutActive = false → langsung ke home
```

**Yang dipelajari:** Navigasi bukan hanya soal "pindah layar" — ini soal siapa yang *memiliki* state navigasi. Kalau state ada di view, susah dikontrol dari luar. Kalau state ada di model, bisa dikontrol dari mana saja.

---

### Platform-Specific API

| API | Platform | Fungsi |
|-----|----------|--------|
| `digitalCrownRotation` | watchOS | Input via tombol putar Watch |
| `WKInterfaceDevice.current().play(.notification)` | watchOS | Haptic / getaran |
| `WCSession.sendMessage` | iOS + watchOS | Kirim data real-time antar device |
| `WCSession.transferUserInfo` | iOS + watchOS | Kirim data antri (background) |
| `CMMotionManager` | watchOS | Baca accelerometer |

**Yang dipelajari:** Setiap platform Apple punya API unik. Kode yang jalan di iOS belum tentu ada di watchOS. Selalu cek dokumentasi platform target.

---

### Lifecycle View

```swift
.onAppear  { manager.start() }   // sensor mulai saat layar tampil
.onDisappear { manager.stop() }  // sensor berhenti saat layar hilang
```

**Yang dipelajari:** Kalau tidak matikan sensor di `onDisappear`, sensor terus jalan di background → boros baterai + data yang dihitung salah. Lifecycle sangat penting untuk resource yang mahal (sensor, timer, network).

---

### Timer

```swift
// Buat timer yang publish setiap 1 detik
let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

// Subscribe di view
.onReceive(timer) { _ in
    elapsedSeconds += 1
}
```

**Yang dipelajari:** Timer di SwiftUI menggunakan pola publish-subscribe (Combine). Timer tidak dimiliki oleh view — timer "menyiarkan" tick, view "mendengarkan". Ini mencegah memory leak.

---

## 2. Algoritma Signal Processing — RepCounterManager

### Masalah yang Diselesaikan

> Bagaimana cara menghitung repetisi gerakan fisik hanya dari data akselerometer, tanpa kamera, tanpa ML model besar?

---

### Konsep 1 — Magnitude (Kekuatan Total Gerakan)

Sensor memberi 3 angka: gerakan di sumbu x, y, z.
Kita butuh 1 angka yang merepresentasikan "seberapa keras gerakan total":

```
magnitude = √(x² + y² + z²)
```

Ini **Euclidean distance** — konsep dasar matematika vektor. Hasilnya: 1 angka, 50x per detik.

---

### Konsep 2 — EMA (Exponential Moving Average)

Data mentah dari sensor sangat "berisik" — naik turun acak karena getaran kecil.
EMA menghaluskan sinyal dengan cara mencampur nilai baru dengan historis:

```
smoothed = (1 - α) × smoothed_lama + α × nilai_baru

α = 0.3  →  campurkan 30% baru + 70% lama
```

Semakin kecil α → sinyal lebih halus tapi lambat respons
Semakin besar α → sinyal lebih cepat tapi berisik

**Analogi:** Seperti rata-rata nilai ujian — nilai kemarin masih mempengaruhi rata-rata hari ini, tapi makin lama makin kecil pengaruhnya.

---

### Konsep 3 — Adaptive Threshold (Ambang Batas Adaptif)

**Masalah dengan threshold tetap:**
- Pull Up menggerakkan seluruh tubuh → magnitude besar
- Bicep Curl hanya lengan → magnitude kecil
- Kalau threshold tetap 1.5, Pull Up terdeteksi tapi Curl tidak (atau sebaliknya)

**Solusi — hitung threshold dari data user itu sendiri:**

```
threshold = mean_gerakan + 0.8 × standar_deviasi_gerakan
```

Artinya: "Anggap ini gerakan signifikan kalau 0.8 standar deviasi di atas rata-ratamu"

Nilai mean dan variance di-update terus (rolling stats) dengan formula yang sama seperti EMA.

**Yang dipelajari:** Dalam signal processing, threshold adaptif jauh lebih robust daripada threshold tetap. Ini prinsip yang sama dipakai di audio noise cancellation, EKG heart rate detection, dsb.

---

### Konsep 4 — State Machine Deteksi Rep

```
State: IDLE
    │
    │ sinyal naik melewati threshold
    ▼
State: ABOVE_THRESHOLD
    │ hitung berapa lama di atas
    │
    │ sinyal turun melewati threshold × 0.65
    ▼
Evaluasi:
    ├── durasi < 0.24 detik? → REJECT (jerk/sentakan, bukan rep)
    ├── jeda sejak rep terakhir < 0.4 detik? → REJECT (double count)
    └── keduanya OK? → ACCEPT: repCount += 1
```

**Hysteresis (0.65):** Sinyal harus turun cukup jauh sebelum dianggap "sudah selesai naik". Ini mencegah rep dihitung 2x karena sinyal bergetar di sekitar threshold.

**Yang dipelajari:** State machine adalah cara elegan untuk melacak "sedang dalam kondisi apa". Konsep ini dipakai di UI (loading/error/success), protokol jaringan, game logic, dan di sini: deteksi gerakan.

---

## 3. Vibe Coding — Apa yang Harus Dipahami

### Definisi Vibe Coding

Menggunakan AI untuk menulis kode, kamu yang mengarahkan.

```
Kamu  → "apa yang ingin dicapai" + "review hasilnya"
AI    → "bagaimana cara kodenya"
```

### Masalahnya

AI bisa salah. Dan kamu harus tahu *kapan* AI salah.

---

### 3 Level Pemahaman yang Dibutuhkan

**Level 1 — Bisa Membaca Kode (Wajib)**
```
Pertanyaan yang harus bisa dijawab:
"Kode ini ngapain?"

Tanpa ini:
→ Tidak bisa review hasil AI
→ Bug masuk tanpa disadari
→ Tidak bisa menjelaskan kode sendiri ke orang lain
```

**Level 2 — Paham Arsitektur (Penting)**
```
Pertanyaan yang harus bisa dijawab:
"Kenapa kode ini diletakkan di sini, bukan di tempat lain?"

Contoh dari project ini:
→ Kenapa logika kirim data ada di WatchSessionManager, bukan di WatchSummaryView?
→ Kenapa navigasi dikontrol dari WatchContentView, bukan dari dalam view?
→ Kenapa pakai transferUserInfo, bukan sendMessage saja?

Tanpa ini:
→ AI bikin keputusan yang masuk akal jangka pendek
   tapi menghasilkan kode yang susah di-maintain
```

**Level 3 — Paham Trade-off (Untuk Skala Lebih Besar)**
```
Pertanyaan yang harus bisa dijawab:
"Apa konsekuensi dari pilihan ini?"

Contoh:
→ @State vs @Observable: kapan mana yang tepat?
→ SwiftData vs UserDefaults: untuk data apa?
→ sendMessage vs transferUserInfo: kapan iPhone app harus terbuka?

Tanpa ini:
→ Susah debug masalah yang muncul 3 bulan kemudian
→ Pilihan "yang mudah sekarang" jadi technical debt
```

---

### Yang Sering Dilewatkan Vibe Coder

| Dilewatkan | Akibatnya |
|-----------|-----------|
| Tidak paham lifecycle | Memory leak, sensor/timer jalan terus di background |
| Tidak paham data flow | State tidak sinkron, UI menampilkan data lama |
| Tidak paham async | Race condition, crash di device asli (bukan simulator) |
| Tidak paham platform constraint | Jalan di simulator, crash di Watch/iPhone asli |
| Tidak bisa debug | Kalau AI tidak bisa solve, kamu juga stuck |
| Tidak paham error | Tidak tahu apakah error dari logika, network, atau framework |

---

### Framework Mental yang Benar

```
❌ "Biarkan AI yang mikir, aku tinggal copy-paste"

✅ "Aku yang memutuskan APA dan MENGAPA,
    AI membantu BAGAIMANA implementasinya,
    Aku yang memverifikasi hasilnya benar"
```

---

### Kesimpulan

> **Vibe coding mempercepat eksekusi, tapi tidak menggantikan pemahaman.**

Di project WGG ini, kamu sudah praktik pola yang benar:
- Kamu yang memutuskan fitur apa yang dibangun
- Kamu yang menentukan UX-nya harus seperti apa
- Kamu yang mendeteksi kalau hasil AI salah atau tidak sesuai
- AI hanya menerjemahkan keputusanmu ke kode Swift

**Itu skill yang lebih berharga daripada hafal syntax.**

Programmer terbaik bukan yang paling banyak hafal kode — tapi yang paling cepat memahami masalah dan memilih solusi yang tepat.

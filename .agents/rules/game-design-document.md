# 🌲 LITTLE FOREST KEEPER
### Game Design Document — Cozy Fall Jam 2026

> **“A tiny forest is counting on you before winter arrives.”**

---

## 1. Game Overview

| Item | Detail |
|---|---|
| **Title** | Little Forest Keeper |
| **Genre** | Cozy Management / Simulation |
| **Subgenre** | Ecosystem / Casual Strategy |
| **Perspective** | Top-down 2D |
| **Platform** | PC / Web |
| **Target Playtime** | 15–30 minutes |
| **Engine** | Unity |
| **Theme** | Autumn / Nature |
| **Optional Theme** | Roots |
| **Target Audience** | Casual players, cozy game fans |
| **Game Jam Scope** | 3 days |

### High Concept

**Little Forest Keeper** adalah game cozy management di mana pemain berperan sebagai penjaga sebuah hutan kecil yang sedang mempersiapkan diri menghadapi musim dingin.

Pemain menempatkan berbagai elemen alam seperti **acorn, mushroom, leaves, branch, dan water** untuk menciptakan kondisi yang dapat menarik berbagai hewan dan menumbuhkan ekosistem.

Semakin seimbang ekosistem yang dibangun, semakin hidup dan indah hutan tersebut.

---

# 2. Game Pillars

Game dibangun berdasarkan tiga pilar utama.

### 🌱 1. Grow

Pemain memulai dengan hutan yang kosong dan sederhana.

> Dari hutan mati → menjadi hutan yang hidup.

---

### 🐿️ 2. Discover

Pemain menemukan hubungan antar elemen ekosistem.

Contoh:

```text
Acorn
  ↓
Squirrel
  ↓
Seed
  ↓
Plant
  ↓
Rabbit
  ↓
Fox
```

Pemain tidak diberi semua informasi sejak awal.

Mereka belajar melalui eksperimen.

---

### 🍂 3. Cozy Transformation

Perubahan visual hutan menjadi reward utama.

Awal:

```text
🌱        🌱

      🪨

   🌱
```

Akhir:

```text
🌲 🐿️ 🍄 🌳 🦌
🍂 🌰 🐇 🌲 🍄
🌳 🦊 🌱 🐿️ 🌲
```

Tujuan akhirnya bukan mendapatkan skor setinggi mungkin.

**Tujuannya adalah membuat pemain merasa:**

> “Aku berhasil membuat hutan ini hidup lagi.”

---

# 3. Player Fantasy

Pemain harus merasa seperti:

> **“Aku adalah penjaga kecil yang membantu alam mempersiapkan diri sebelum musim dingin.”**

Pemain bukan seorang administrator atau city builder.

Pemain lebih seperti:

- caretaker
- gardener
- forest spirit
- ecosystem guardian

Setiap keputusan kecil pemain menghasilkan perubahan pada lingkungan.

---

# 4. Core Gameplay Loop

Core loop:

```text
        EXPLORE
           ↓
     FIND RESOURCES
           ↓
     PLACE RESOURCES
           ↓
    ATTRACT ORGANISMS
           ↓
     ECOSYSTEM GROWS
           ↓
     UNLOCK NEW SPECIES
           ↓
       FOREST CHANGES
           ↓
          REPEAT
```

Contoh:

```text
Player finds Acorn
        ↓
Places Acorn
        ↓
Squirrel appears
        ↓
Squirrel plants seed
        ↓
Seed becomes plant
        ↓
Rabbit appears
        ↓
Forest becomes more alive
```

---

# 5. Main Gameplay

## 5.1 Player Movement

Pemain mengontrol karakter Little Forest Keeper dari perspektif top-down.

### Controls

| Input | Action |
|---|---|
| WASD | Move |
| Mouse | Aim / interact |
| Left Click | Place resource |
| E | Interact |
| ESC | Pause |

Movement harus sederhana agar fokus tetap pada ecosystem.

---

# 6. Resource System

Pemain dapat menemukan beberapa resource alami.

## 🌰 Acorn

Fungsi:

- Menarik squirrel.
- Dapat menjadi sumber seed.
- Membantu perkembangan forest.

```text
Acorn
  ↓
Squirrel
  ↓
Seed
```

---

## 🍄 Mushroom

Fungsi:

- Menambah biodiversity.
- Menjadi habitat makanan beberapa hewan.
- Meningkatkan forest health.

```text
Mushroom
    ↓
Biodiversity
    ↓
More animals
```

---

## 🍂 Leaves

Fungsi:

- Membuat area lebih nyaman.
- Menjadi nesting material.
- Mempercepat beberapa proses pertumbuhan.

---

## 🪵 Branch

Fungsi:

- Digunakan sebagai shelter.
- Tempat beberapa hewan beraktivitas.
- Dapat dikombinasikan dengan leaves.

```text
Branch + Leaves
       ↓
     Nest
```

---

## 💧 Water

Fungsi:

- Menjaga tanaman tetap hidup.
- Menarik hewan tertentu.
- Membuka area baru.

---

# 7. Ecosystem System

Sistem utama game adalah **chain reaction ecosystem**.

Setiap organisme mempunyai kebutuhan tertentu.

## Basic Ecosystem

```text
🌰 ACORN
   │
   ↓
🐿️ SQUIRREL
   │
   ↓
🌱 SEED
   │
   ↓
🌿 PLANT
   │
   ↓
🐇 RABBIT
   │
   ↓
🦊 FOX
```

Pemain tidak secara langsung "spawn" hewan.

Sebaliknya, pemain menciptakan kondisi agar hewan tersebut muncul.

---

# 8. Animal System

## 🐿️ Squirrel

### Requirement

- Acorn
- Tree / vegetation

### Behavior

Squirrel:

1. Mencari acorn.
2. Mengambil acorn.
3. Membawa acorn.
4. Menanam seed di lokasi tertentu.
5. Pergi mencari makanan lagi.

### Contribution

```text
Squirrel
    ↓
Seed
    ↓
More Plants
```

---

# 🐇 Rabbit

### Requirement

- Vegetation
- Grass
- Water

### Behavior

Rabbit:

- mencari makanan
- makan vegetation
- berpindah area
- berkembang biak jika ecosystem cukup sehat

### Contribution

Rabbit menjadi indikator bahwa forest sudah mulai sehat.

---

# 🦊 Fox

### Requirement

- Rabbit population
- Dense vegetation
- Forest health tinggi

### Behavior

Fox tidak langsung menyerang pemain.

Fox:

- berjalan di sekitar forest
- berburu secara natural
- tidur di area tertentu

### Contribution

Fox menjadi tanda bahwa ecosystem sudah mencapai tahap tinggi.

---

# 🦌 Deer

### Requirement

- Forest health tinggi
- Water source
- Dense vegetation

Deer merupakan salah satu **rare animal**.

Kemunculannya menjadi salah satu milestone besar pemain.

---

# 9. Ecosystem Dependency

Sistem ecosystem dapat digambarkan sebagai:

```text
               🌳 TREES
                  │
                  ↓
             🌰 ACORNS
                  │
                  ↓
             🐿️ SQUIRREL
                  │
                  ↓
              🌱 SEEDS
                  │
                  ↓
             🌿 PLANTS
               /     \
              ↓       ↓
          🐇 RABBIT  🦌 DEER
              │
              ↓
          🦊 FOX
```

Namun tidak semua hubungan bersifat linear.

Beberapa organisme memiliki beberapa requirement.

Contoh:

```text
             WATER
                │
                ↓
          ┌───────────┐
          │  PLANTS   │
          └─────┬─────┘
                │
       ┌────────┼────────┐
       ↓        ↓        ↓
    🐇 Rabbit  🦌 Deer  🍄 Mushroom
       │
       ↓
    🦊 Fox
```

---

# 10. Forest Health

Forest memiliki satu parameter utama:

## 🌲 Forest Health

Range:

```text
0 ─────────────────── 100
```

### Forest Health dipengaruhi oleh:

Positive:

- Trees
- Plants
- Water
- Mushrooms
- Animals
- Biodiversity

Negative:

- Dead zones
- Lack of water
- Overpopulation
- Unbalanced ecosystem

---

## Forest State

### 0–20

**Dead Forest**

```text
🌱     🪨
     
        🌱
```

Tidak banyak kehidupan.

---

### 20–40

**Recovering Forest**

```text
🌱 🍄

      🌳

   🌱
```

Mulai ada kehidupan.

---

### 40–70

**Healthy Forest**

```text
🌲 🐿️ 🍄 🌳
🍂 🌰 🌱 🐇
```

Banyak organisme mulai muncul.

---

### 70–90

**Thriving Forest**

```text
🌲 🐿️ 🍄 🌳 🦌
🍂 🌰 🐇 🌲 🍄
🌳 🌱 🦊 🐿️ 🌲
```

Ekosistem mulai stabil.

---

### 90–100

**Perfect Autumn Forest**

Forest mencapai kondisi ideal sebelum winter.

```text
🌲 🌳 🍂 🐿️ 🦌
🍄 🌰 🐇 🌳 🍂
🌲 🦊 🌱 🍄 🐿️
```

---

# 11. Progression

Game dibagi menjadi beberapa tahap.

## Stage 1 — Awakening

Goal:

> Make the forest alive again.

Available:

- Acorn
- Water
- Leaves

First animal:

🐿️ Squirrel

---

## Stage 2 — Growth

Goal:

> Grow enough vegetation.

Unlocked:

- Mushroom
- Branch
- More plants

Animal:

🐇 Rabbit

---

## Stage 3 — Balance

Goal:

> Create a balanced ecosystem.

Unlocked:

- Advanced plants
- Nest
- More water sources

Animal:

🦊 Fox

---

## Stage 4 — Harmony

Goal:

> Reach maximum forest health.

Rare animal:

🦌 Deer

---

## Stage 5 — Winter

Goal:

> Prepare the forest before winter arrives.

Once the player reaches the required Forest Health:

🍂 leaves begin falling.

Temperature drops.

The player receives a final task:

> **Make sure the forest is ready for winter.**

---

# 12. Winter Preparation

This is the final gameplay challenge.

Player must ensure:

- enough food
- enough vegetation
- sufficient water
- enough shelter
- stable animal population

Example:

```text
🌰 Food       ████████░░
💧 Water      █████████░
🌿 Vegetation ██████████
🏠 Shelter    ███████░░░
```

If requirements are fulfilled:

```text
              ❄️
          ❄️     ❄️

      🌲 🦌 🌲
   🐇 🍄 🐿️ 🍂
      🦊 🌳

        WINTER
       IS READY
```

---

# 13. The "Roots" Theme

The optional jam theme **Roots** dapat dimasukkan secara natural.

Roots memiliki dua makna.

### Literal

Akar merupakan bagian penting dari ecosystem.

Pemain dapat menemukan:

🌱 Root

yang meningkatkan:

- plant growth
- water absorption
- soil health

---

### Metaphorical

Hutan bukan hanya kumpulan objek.

Semua kehidupan saling terhubung.

```text
       🌳
       │
   ────┼────
      ROOT
   ────┼────
       │
   🌱   🌱   🌱
    │   │   │
    └───┴───┘
```

**Every living thing is connected.**

---

# 14. Map Design

Map dibuat sebagai satu area kecil.

Tidak perlu open world.

### Example

```text
┌───────────────────────────────┐
│ 🌲        🍄         🌲       │
│                               │
│       🌰            🪨        │
│                               │
│ 🍂          💧               │
│                               │
│              🌳               │
│                               │
│     🌱              🪵        │
│                               │
│ 🐿️                    🌲      │
└───────────────────────────────┘
```

Map kemudian berubah berdasarkan tindakan pemain.

---

# 15. Visual Transformation

Perubahan lingkungan adalah salah satu fitur paling penting.

## Beginning

Warna lebih kosong.

```text
🌱        🪨

       🌱

   🪨        🌱
```

---

## Mid Game

```text
🌲      🍄
    🌱       🐿️

🍂      🌳
        🌰
```

---

## End Game

```text
🌲 🐿️ 🍄 🌳 🦌
🍂 🌰 🐇 🌲 🍄
🌳 🦊 🌱 🐿️ 🌲
```

### Visual Feedback

Setiap perkembangan memberikan feedback:

- new plant animation
- leaves falling
- animals entering screen
- flowers blooming
- water animation
- ambient particles
- birds flying
- changing background ambience

---

# 16. Cozy Atmosphere

## Color Direction

Palet:

- warm orange
- muted green
- brown
- cream
- soft yellow

Avoid:

- overly saturated colors
- dark horror aesthetic
- aggressive UI

---

# 17. Audio Design

Audio harus sederhana tetapi memberikan rasa cozy.

### Ambient

- wind
- birds
- leaves
- water
- insects

### Interaction

Resource placement:

> *pop*

Plant growth:

> *sparkle*

Animal arrival:

> *soft chime*

Forest milestone:

> *warm musical chord*

---

# 18. Music

Music berubah berdasarkan Forest Health.

### 0–30

Minimal.

```text
Soft piano
```

### 30–60

Tambah:

```text
Acoustic instrument
```

### 60–90

Tambah:

```text
Warm melody
```

### 90–100

Full cozy arrangement.

Dengan begitu pemain dapat **merasakan perkembangan forest tanpa membaca UI.**

---

# 19. UI

UI dibuat minimal.

### Top-left

```text
🌲 FOREST HEALTH

████████░░ 78%
```

### Top-right

```text
🍂 AUTUMN DAY 4
```

### Bottom

Resource bar:

```text
🌰  x3
🍄  x2
🍂  x5
🪵  x2
💧  x1
```

---

# 20. Discovery UI

Pemain dapat membuka:

## 📖 Forest Journal

Contoh:

```text
┌──────────────────────────┐
│      FOREST JOURNAL      │
├──────────────────────────┤
│                          │
│ 🐿️ SQUIRREL              │
│                          │
│ "Loves acorns."          │
│                          │
│ Requirement:             │
│ 🌰 Acorn                 │
│ 🌳 Tree                  │
│                          │
└──────────────────────────┘
```

Journal awalnya memiliki silhouette.

Contoh:

```text
🐿️  ✓
🐇  ✓
🦊  ?
🦌  ?
```

Hal ini mendorong eksplorasi.

---

# 21. Reward System

Tidak menggunakan currency yang kompleks.

Reward utama:

### 1. New Species

🐿️ → 🐇 → 🦊 → 🦌

### 2. New Plants

🌱 → 🌿 → 🌳

### 3. Forest Transformation

Dead → Healthy → Thriving

### 4. Journal Completion

Pemain dapat melihat seluruh ecosystem yang berhasil ditemukan.

---

# 22. Win Condition

Pemain menang ketika:

```text
Forest Health >= 90
        +
Required Species Discovered
        +
Winter Preparation Complete
```

Kemudian masuk ke ending.

### Ending Scene

Kamera perlahan zoom out.

Hutan terlihat penuh kehidupan.

Salju pertama mulai turun.

Hewan-hewan kembali ke shelter masing-masing.

Little Forest Keeper duduk di bawah pohon.

Text:

> **“Winter can wait. The forest is ready.”**

Kemudian:

```text
🌲 LITTLE FOREST KEEPER 🌲

FOREST RESTORED

🐿️ 12
🐇 8
🦊 2
🦌 1

FOREST HEALTH
██████████ 100%

Thank you, Keeper.
```

---

# 23. Game Feel

Hal yang harus terasa setiap kali pemain melakukan sesuatu:

### Place Resource

```text
CLICK
 ↓
resource appears
 ↓
small bounce
 ↓
soft sound
 ↓
particles
```

### Animal Arrives

```text
forest rustles
 ↓
animal walks in
 ↓
small notification
 ↓
animal starts behavior
```

### New Species

```text
screen slightly pauses
 ↓
soft sound
 ↓
journal unlock
 ↓
"New friend discovered!"
```

---

# 24. MVP Scope

Karena game dibuat untuk game jam 3 hari, MVP harus sangat terbatas.

## Required

### Player

- movement
- interaction

### Resources

- Acorn
- Mushroom
- Leaves
- Branch
- Water

### Animals

- Squirrel
- Rabbit
- Fox
- Deer

### Plants

- Grass
- Bush
- Tree

### Systems

- resource placement
- ecosystem requirements
- animal spawning
- forest health
- day progression
- win condition

### UI

- forest health
- resource inventory
- journal
- win screen

---

# 25. Cut List

Jika waktu hampir habis, fitur berikut **HARUS dipotong terlebih dahulu**:

1. Complex animal AI
2. Breeding
3. Dynamic weather
4. Multiple maps
5. Crafting
6. Complex inventory
7. Quest system
8. NPC
9. Save system
10. Multiple endings

Jangan menambah fitur baru sebelum core loop benar-benar playable.

---

# 26. 3-Day Development Plan

## DAY 1 — Core Gameplay

### Morning

- Player movement
- Camera
- Map
- Resource pickup

### Afternoon

- Resource placement
- Forest Health
- Basic plant growth

### Evening

- Squirrel AI
- Acorn → Squirrel → Seed chain

**Target Day 1:**

```text
Player
  ↓
Acorn
  ↓
Squirrel
  ↓
Seed
  ↓
Plant
```

Sudah playable.

---

# DAY 2 — Ecosystem

### Morning

Implement:

- Rabbit
- Fox
- Deer

### Afternoon

Implement:

- ecosystem requirements
- animal spawning
- Forest Health
- progression

### Evening

Implement:

- Journal
- UI
- win condition

**Target Day 2:**

```text
Full gameplay loop playable.
```

---

# DAY 3 — Polish

## Morning

Visual polish:

- environment
- particles
- animation
- UI

## Afternoon

Audio:

- music
- ambience
- SFX

## Evening

Final polish:

- tutorial
- balancing
- bug fixing
- WebGL build
- itch.io page

**Day 3 jangan menambah sistem besar.**

---

# 27. Tutorial

Tutorial harus hampir tanpa text.

### Step 1

Highlight acorn.

```text
🌰

"Place this."
```

Player klik.

---

### Step 2

Squirrel muncul.

```text
🐿️

"Someone came!"
```

---

### Step 3

Squirrel menanam seed.

```text
🐿️ → 🌱
```

---

### Step 4

Plant tumbuh.

```text
🌱 → 🌿 → 🌳
```

---

### Step 5

Rabbit datang.

```text
🐇

"Your forest is growing!"
```

Setelah itu tutorial selesai.

---

# 28. Unique Selling Point

### One-Sentence USP

> **A cozy forest management game where every tiny action creates a chain reaction that brings an ecosystem to life.**

### Short USP

> **You don't build the forest. You help nature build itself.**

Ini menjadi prinsip utama desain game.

---

# 29. What Makes It Different?

Game management biasanya:

```text
Build
↓
Upgrade
↓
Build more
↓
Get more resources
```

Little Forest Keeper:

```text
Observe
↓
Understand
↓
Place
↓
Nature reacts
↓
Discover
```

Pemain tidak mengontrol semuanya.

Pemain **menciptakan kondisi agar alam bekerja sendiri.**

---

# 30. Emotional Goal

Game harus menghasilkan tiga perasaan utama:

### Beginning

> “Hutannya sepi banget.”

### Mid Game

> “Oh, ternyata kalau aku taruh acorn di sini, squirrel datang!”

### End Game

> “Wah, hutannya jadi hidup.”

Target akhir:

> **“Aku yang membuat tempat ini hidup.”**

---

# 31. Jam Competition Strategy

Karena game dibuat untuk game jam, fokus utama development:

```text
                CORE
                  │
        ┌─────────┴─────────┐
        ↓                   ↓
  ECOSYSTEM CHAIN     VISUAL CHANGE
        │                   │
        └─────────┬─────────┘
                  ↓
             COZY FEEL
                  ↓
            PRESENTATION
```

Prioritas:

### P0 — Must Have

- Movement
- Resource placement
- Ecosystem chain
- Animal spawning
- Forest Health
- Win condition

### P1 — Important

- Animation
- Particles
- SFX
- Music
- Journal
- Forest transformation

### P2 — Nice to Have

- Weather
- More species
- More plants
- Advanced AI
- Random events

---

# 32. Final Player Experience

Target pengalaman pemain:

```text
START
 ↓
Empty forest
 ↓
"What do I do?"
 ↓
Place acorn
 ↓
🐿️ appears
 ↓
"Oh!"
 ↓
Squirrel plants seed
 ↓
🌱 grows
 ↓
🐇 appears
 ↓
"Wait... everything is connected."
 ↓
Player experiments
 ↓
Forest becomes beautiful
 ↓
🦊 appears
 ↓
🦌 appears
 ↓
Winter arrives
 ↓
Forest survives
 ↓
❤️
```

---

# 33. Final Tagline

> ## 🌲 “You don't build the forest. You help it grow.”

---

# 34. Pitch Singkat

**Little Forest Keeper** adalah cozy ecosystem management game di mana pemain menjadi penjaga hutan kecil yang harus mempersiapkan hutan menghadapi musim dingin.

Alih-alih membangun semuanya secara langsung, pemain menempatkan elemen alam seperti acorn, mushroom, water, dan branches untuk menciptakan kondisi yang memungkinkan kehidupan berkembang secara alami.

Acorn menarik squirrel. Squirrel menyebarkan seed. Seed menumbuhkan tanaman. Tanaman menarik rabbit. Rabbit memungkinkan predator seperti fox muncul.

**Setiap keputusan kecil menciptakan chain reaction yang membuat hutan semakin hidup.**

Pada akhirnya, pemain tidak hanya menyelesaikan sebuah level.

Mereka melihat sebuah hutan kosong yang perlahan berubah menjadi ekosistem yang hidup.

> **You don't build the forest. You help it grow.**
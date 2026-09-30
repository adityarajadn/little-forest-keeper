# Audio Manager Lite — drop-in sound system for Godot 4 (free)

A pooled `AudioManager` autoload that plays SFX without sounds cutting each
other off, handles background music, and saves per-bus volume to disk. Add the
plugin and you're done — no boilerplate.

```gdscript
# Play a sound — never cuts off what's already playing:
AudioManager.play_sfx(preload("res://sounds/coin.wav"))

# Music:
AudioManager.play_music(preload("res://music/theme.ogg"))
AudioManager.stop_music()

# Volume (0.0 .. 1.0) — persisted across sessions automatically:
AudioManager.set_master_volume(0.8)
AudioManager.set_music_volume(0.5)
AudioManager.set_sfx_volume(1.0)
AudioManager.save_settings()   # writes user://audio.cfg
```

The autoload keeps a small pool of `AudioStreamPlayer` nodes so overlapping SFX
(footsteps, gunshots, coins) never stomp on each other. Run the included demo
(`demo/demo.tscn`) to see it live.

## Install
1. Copy the `addons/audio_manager_lite` folder into your project.
2. Enable **Audio Manager Lite** in *Project → Project Settings → Plugins*
   (registers the `AudioManager` autoload).
3. Call `AudioManager.play_sfx(stream)` from anywhere.

## Lite vs PRO

| Feature | Lite (free) | **PRO** |
|---|:---:|:---:|
| Pooled SFX (no cut-off) | ✅ | ✅ |
| Background music | ✅ | ✅ |
| Per-bus volume (Master/Music/SFX) | ✅ | ✅ |
| Save/load volume to disk | ✅ | ✅ |
| **Music crossfade** | — | ✅ |
| **2D positional audio** | — | ✅ |
| **3D positional audio** | — | ✅ |
| **String key sound library** | — | ✅ |
| **Auto-register folder** | — | ✅ |
| **Music ducking during SFX** | — | ✅ |
| **Random pitch variation** | — | ✅ |

PRO uses the same `AudioManager` autoload and class name — upgrading is drop-in.
**Get Audio Manager PRO:**
👉 https://godot-forge.itch.io/audio-manager-godot

## License
MIT — free for commercial and personal projects. See `LICENSE.txt`.

Made by **GodotForge** · more Godot tools: https://godot-forge.itch.io

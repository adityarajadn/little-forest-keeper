"""Generate animated promo GIF for Audio Manager PRO.
Shows key API calls appearing one by one with feature badges.
Run: python _make_gif.py
"""
from PIL import Image, ImageDraw, ImageFont
import os

BASE   = os.path.dirname(os.path.abspath(__file__))
ORANGE = (230, 126, 34)
DARK   = (24, 26, 38)
PANEL  = (33, 36, 52)
WHITE  = (235, 238, 245)
MUTED  = (140, 148, 168)
CODE   = (130, 220, 160)
BADGE  = (44, 48, 68)
W, H   = 640, 400

try:
    title_f = ImageFont.truetype("C:/Windows/Fonts/segoeuib.ttf", 28)
    code_f  = ImageFont.truetype("C:/Windows/Fonts/consola.ttf",  20)
    badge_f = ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf",  17)
    small_f = ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf",  15)
except:
    title_f = code_f = badge_f = small_f = ImageFont.load_default()

STEPS = [
    {
        "badge": "🔊 Pooled SFX — sounds never cut off",
        "lines": [
            ("# register once:", MUTED),
            ('AudioManager.register("coin", stream)', CODE),
            ("", WHITE),
            ("# play anywhere — pooled:", MUTED),
            ('AudioManager.play_sfx("coin")', CODE),
        ],
    },
    {
        "badge": "🎵 Music crossfade",
        "lines": [
            ("# smooth transition:", MUTED),
            ('AudioManager.play_music("boss", crossfade=1.5)', CODE),
            ("", WHITE),
            ("# stop with fade:", MUTED),
            ('AudioManager.stop_music(fade=0.8)', CODE),
        ],
    },
    {
        "badge": "📍 2D & 3D positional audio",
        "lines": [
            ("# 2D — frees itself when done:", MUTED),
            ('AudioManager.play_sfx_2d("boom", pos)', CODE),
            ("", WHITE),
            ("# 3D:", MUTED),
            ('AudioManager.play_sfx_3d("boom", pos3d)', CODE),
        ],
    },
    {
        "badge": "🎚 Volume saved to disk",
        "lines": [
            ("# per-bus control:", MUTED),
            ('AudioManager.set_music_volume(0.6)', CODE),
            ('AudioManager.set_sfx_volume(0.9)', CODE),
            ("", WHITE),
            ('AudioManager.save_settings()  # user://audio.cfg', CODE),
        ],
    },
    {
        "badge": "🦆 Ducking + pitch variation",
        "lines": [
            ("# music lowers during SFX:", MUTED),
            ('AudioManager.duck_amount     = 0.3', CODE),
            ('AudioManager.duck_release    = 0.4', CODE),
            ("", WHITE),
            ('AudioManager.pitch_variation = 0.08', CODE),
        ],
    },
]


def make_frame(step: dict, alpha: float = 1.0) -> Image.Image:
    img = Image.new("RGB", (W, H), DARK)
    d = ImageDraw.Draw(img)

    # top accent bar
    d.rectangle([0, 0, W, 5], fill=ORANGE)

    # title
    d.text((20, 18), "Audio Manager PRO", font=title_f, fill=WHITE)
    d.text((20, 54), "for Godot 4", font=small_f, fill=MUTED)

    # icon bars (mini logo)
    bar_h = [18, 30, 40, 30, 18]
    bar_w = 8
    gap   = 5
    tot   = len(bar_h) * bar_w + (len(bar_h) - 1) * gap
    x0    = W - tot - 20
    for i, bh in enumerate(bar_h):
        x = x0 + i * (bar_w + gap)
        y = 18 + (40 - bh) // 2
        d.rounded_rectangle([x, y, x + bar_w, y + bh], radius=3, fill=ORANGE)

    # badge pill
    badge_txt = step["badge"]
    bw = int(d.textlength(badge_txt, font=badge_f)) + 28
    d.rounded_rectangle([20, 82, 20 + bw, 112], radius=14, fill=BADGE)
    d.rectangle([20, 82, 34, 112], fill=ORANGE)
    d.rounded_rectangle([20, 82, 34, 112], radius=14, fill=ORANGE)
    d.text((48, 88), badge_txt, font=badge_f, fill=WHITE)

    # code panel
    panel_y = 128
    d.rounded_rectangle([16, panel_y, W - 16, H - 20], radius=12, fill=PANEL)

    y = panel_y + 18
    for text, color in step["lines"]:
        if text:
            d.text((36, y), text, font=code_f, fill=color)
        y += 34

    # bottom hint
    d.text((20, H - 16), "godot-forge.itch.io/audio-manager-godot", font=small_f, fill=MUTED)

    return img


def frames_for_step(step, n_hold=14, n_fade=4):
    """Return list of (image, duration_ms) tuples for one step."""
    out = []
    # hold
    img = make_frame(step)
    for _ in range(n_hold):
        out.append((img, 120))
    # fade-out (just darken slightly)
    for i in range(n_fade):
        faded = img.copy()
        overlay = Image.new("RGB", (W, H), DARK)
        ratio = (i + 1) / (n_fade + 1)
        blended = Image.blend(faded, overlay, ratio * 0.5)
        out.append((blended, 60))
    return out


all_frames = []
durations  = []
for step in STEPS:
    for img, ms in frames_for_step(step):
        all_frames.append(img)
        durations.append(ms)

out_path = os.path.join(BASE, "audio_manager_demo.gif")
all_frames[0].save(
    out_path,
    save_all=True,
    append_images=all_frames[1:],
    loop=0,
    duration=durations,
    optimize=False,
)
print(f"wrote {out_path}  ({len(all_frames)} frames)")

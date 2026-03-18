"""
Generate WAV audio files for boxing timer sound packs.

Creates three sound packs:
  - classic_bell/   (copies existing bell sounds)
  - digital_buzzer/ (electronic, sharp, punchy)
  - minimal_beep/   (quiet, subtle sine waves)

Also keeps the original flat files at the top level for backward compatibility.

No external dependencies - uses only Python stdlib (wave, struct, math).
"""

import wave
import struct
import math
import random
import os
import shutil

SAMPLE_RATE = 44100
BITS_PER_SAMPLE = 16
MAX_AMPLITUDE = 32767  # 16-bit signed max
NUM_CHANNELS = 1

SOUNDS_DIR = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "assets",
    "sounds",
)

SOUND_FILES = ["round_start.wav", "warning.wav", "round_end.wav", "session_complete.wav"]
SOUND_PACKS = ["classic_bell", "digital_buzzer", "minimal_beep"]


# ---------------------------------------------------------------------------
# Low-level WAV writing
# ---------------------------------------------------------------------------

def write_wav(filepath: str, samples: list):
    """Write a list of float samples [-1.0, 1.0] to a 16-bit mono WAV file."""
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    with wave.open(filepath, "wb") as w:
        w.setnchannels(NUM_CHANNELS)
        w.setsampwidth(2)  # 16-bit = 2 bytes
        w.setframerate(SAMPLE_RATE)

        int_samples = []
        for s in samples:
            clamped = max(-1.0, min(1.0, s))
            int_samples.append(int(clamped * MAX_AMPLITUDE))

        data = struct.pack(f"<{len(int_samples)}h", *int_samples)
        w.writeframes(data)

    file_size = os.path.getsize(filepath)
    duration = len(samples) / SAMPLE_RATE
    basename = os.path.relpath(filepath, SOUNDS_DIR)
    print(f"  {basename}: {duration:.3f}s, {file_size:,} bytes ({file_size / 1024:.1f} KB)")


# ---------------------------------------------------------------------------
# Waveform primitives
# ---------------------------------------------------------------------------

def sine_wave(freq: float, duration: float, amplitude: float = 0.7) -> list:
    """Generate a pure sine wave."""
    n = int(duration * SAMPLE_RATE)
    return [amplitude * math.sin(2.0 * math.pi * freq * i / SAMPLE_RATE) for i in range(n)]


def square_wave(freq: float, duration: float, amplitude: float = 0.7) -> list:
    """Generate a band-limited square wave (sum of odd harmonics)."""
    n = int(duration * SAMPLE_RATE)
    samples = [0.0] * n
    # Use first 10 odd harmonics for a clean but sharp square
    for k in range(1, 20, 2):
        harmonic_freq = freq * k
        if harmonic_freq > SAMPLE_RATE / 2:
            break
        coeff = amplitude * (4.0 / (math.pi * k))
        for i in range(n):
            samples[i] += coeff * math.sin(2.0 * math.pi * harmonic_freq * i / SAMPLE_RATE)
    return samples


def sweep(start_freq: float, end_freq: float, duration: float, amplitude: float = 0.7) -> list:
    """Generate a linear frequency sweep (chirp)."""
    n = int(duration * SAMPLE_RATE)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        # Instantaneous frequency linearly interpolated
        f = start_freq + (end_freq - start_freq) * (t / duration)
        phase = 2.0 * math.pi * (start_freq * t + (end_freq - start_freq) * t * t / (2.0 * duration))
        samples.append(amplitude * math.sin(phase))
    return samples


# ---------------------------------------------------------------------------
# Envelope helpers
# ---------------------------------------------------------------------------

def apply_fade(samples: list, fade_in_ms: float = 5.0, fade_out_ms: float = 5.0) -> list:
    """Apply fade-in and fade-out to prevent clicks."""
    n = len(samples)
    fade_in_samples = int(fade_in_ms / 1000.0 * SAMPLE_RATE)
    fade_out_samples = int(fade_out_ms / 1000.0 * SAMPLE_RATE)

    for i in range(min(fade_in_samples, n)):
        samples[i] *= i / fade_in_samples

    for i in range(min(fade_out_samples, n)):
        idx = n - 1 - i
        samples[idx] *= i / fade_out_samples

    return samples


def apply_amplitude_envelope(samples: list, attack_ms: float = 5.0, decay_ms: float = 0.0) -> list:
    """Apply a simple attack-sustain-decay envelope."""
    n = len(samples)
    attack_samples = int(attack_ms / 1000.0 * SAMPLE_RATE)
    decay_samples = int(decay_ms / 1000.0 * SAMPLE_RATE) if decay_ms > 0 else 0

    for i in range(min(attack_samples, n)):
        samples[i] *= i / attack_samples

    if decay_samples > 0:
        for i in range(min(decay_samples, n)):
            idx = n - 1 - i
            samples[idx] *= i / decay_samples

    return samples


def mix(a: list, b: list, b_offset: int = 0) -> list:
    """Mix two sample lists together, with b starting at b_offset samples into a."""
    length = max(len(a), len(b) + b_offset)
    result = [0.0] * length
    for i in range(len(a)):
        result[i] += a[i]
    for i in range(len(b)):
        idx = i + b_offset
        if idx < length:
            result[idx] += b[i]
    return result


def silence(duration: float) -> list:
    """Generate silence of given duration."""
    return [0.0] * int(duration * SAMPLE_RATE)


def normalize(samples: list, peak_level: float = 0.95) -> list:
    """Normalize to peak_level."""
    peak = max(abs(s) for s in samples) if samples else 0
    if peak > 0:
        scale = peak_level / peak
        return [s * scale for s in samples]
    return samples


def concat(*parts) -> list:
    """Concatenate multiple sample lists."""
    result = []
    for p in parts:
        result.extend(p)
    return result


# ---------------------------------------------------------------------------
# Classic bell generator (existing logic preserved)
# ---------------------------------------------------------------------------

def generate_bell_strike(
    duration: float,
    fundamental: float = 900.0,
    harmonics=None,
    attack_ms: float = 2.0,
    decay_rate: float = 4.0,
    noise_duration_ms: float = 8.0,
    noise_amplitude: float = 0.3,
    amplitude: float = 0.85,
) -> list:
    """Generate a single bell strike sound with additive synthesis."""
    if harmonics is None:
        harmonics = [
            (1.0, 1.0, 1.0),
            (2.0, 0.6, 1.5),
            (2.76, 0.4, 2.0),
            (3.0, 0.25, 2.2),
            (4.07, 0.15, 3.0),
            (5.4, 0.08, 3.5),
            (6.12, 0.05, 4.0),
        ]

    num_samples = int(duration * SAMPLE_RATE)
    samples = [0.0] * num_samples

    attack_samples = int(attack_ms / 1000.0 * SAMPLE_RATE)
    noise_samples = int(noise_duration_ms / 1000.0 * SAMPLE_RATE)

    rng = random.Random(int(fundamental * 1000 + decay_rate * 100))

    for i in range(num_samples):
        t = i / SAMPLE_RATE

        if i < attack_samples:
            attack_env = i / attack_samples
        else:
            attack_env = 1.0

        sample = 0.0
        for freq_ratio, harm_amp, decay_mult in harmonics:
            freq = fundamental * freq_ratio
            env = math.exp(-decay_rate * decay_mult * t)
            sample += harm_amp * env * math.sin(2.0 * math.pi * freq * t)

        sample *= attack_env

        if i < noise_samples:
            noise_env = 1.0 - (i / noise_samples)
            noise_env *= noise_env
            noise = rng.uniform(-1.0, 1.0) * noise_amplitude * noise_env
            noise *= (0.5 + 0.5 * math.sin(2.0 * math.pi * 3500.0 * t))
            sample += noise

        samples[i] = sample * amplitude

    peak = max(abs(s) for s in samples)
    if peak > 0:
        scale = min(1.0, 0.95 / peak)
        samples = [s * scale for s in samples]

    return samples


def apply_fade_out(samples: list, fade_ms: float = 20.0) -> list:
    """Apply a short fade-out at the end to prevent clicks."""
    fade_samples = int(fade_ms / 1000.0 * SAMPLE_RATE)
    n = len(samples)
    for i in range(fade_samples):
        idx = n - fade_samples + i
        if 0 <= idx < n:
            samples[idx] *= 1.0 - (i / fade_samples)
    return samples


# ---------------------------------------------------------------------------
# Classic bell pack (regenerate from scratch)
# ---------------------------------------------------------------------------

def generate_classic_bell():
    """Generate the classic_bell sound pack."""
    pack_dir = os.path.join(SOUNDS_DIR, "classic_bell")
    os.makedirs(pack_dir, exist_ok=True)

    bell_harmonics = [
        (1.0, 1.0, 1.0),
        (2.0, 0.55, 1.4),
        (2.76, 0.45, 1.8),
        (3.0, 0.3, 2.0),
        (4.07, 0.18, 2.8),
        (5.4, 0.1, 3.2),
        (6.58, 0.06, 4.0),
    ]

    # --- round_start.wav: single bell strike ---
    print("  classic_bell/round_start.wav (single bell strike)")
    strike = generate_bell_strike(
        duration=1.0,
        fundamental=880.0,
        attack_ms=1.5,
        decay_rate=3.5,
        noise_duration_ms=10.0,
        noise_amplitude=0.35,
        amplitude=0.9,
        harmonics=bell_harmonics,
    )
    strike = apply_fade_out(strike, fade_ms=30.0)
    write_wav(os.path.join(pack_dir, "round_start.wav"), strike)
    # Also write to top level for backward compat
    write_wav(os.path.join(SOUNDS_DIR, "round_start.wav"), strike)

    # --- warning.wav: double clapper ---
    print("  classic_bell/warning.wav (double clapper)")
    clapper_harmonics = [
        (1.0, 1.0, 1.0),
        (1.5, 0.7, 1.5),
        (2.3, 0.5, 2.0),
        (3.1, 0.35, 2.5),
        (4.7, 0.2, 3.5),
        (6.3, 0.12, 4.5),
        (8.1, 0.06, 5.5),
    ]
    strike_duration = 0.5
    spacing = 0.16
    total_duration = spacing + strike_duration + 0.2
    num_samples = int(total_duration * SAMPLE_RATE)
    combined = [0.0] * num_samples

    for strike_idx in range(2):
        offset_samples = int(strike_idx * spacing * SAMPLE_RATE)
        s = generate_bell_strike(
            duration=strike_duration,
            fundamental=1200.0 + strike_idx * 30.0,
            attack_ms=1.0,
            decay_rate=6.0,
            noise_duration_ms=6.0,
            noise_amplitude=0.4,
            amplitude=0.85,
            harmonics=clapper_harmonics,
        )
        for i, v in enumerate(s):
            target = offset_samples + i
            if target < num_samples:
                combined[target] += v

    combined = normalize(combined)
    combined = apply_fade_out(combined, fade_ms=20.0)
    write_wav(os.path.join(pack_dir, "warning.wav"), combined)
    write_wav(os.path.join(SOUNDS_DIR, "warning.wav"), combined)

    # --- round_end.wav: triple bell strike ---
    print("  classic_bell/round_end.wav (triple bell strike)")
    strike_duration = 0.8
    spacing = 0.32
    total_duration = spacing * 2 + strike_duration + 0.3
    num_samples = int(total_duration * SAMPLE_RATE)
    combined = [0.0] * num_samples

    for strike_idx in range(3):
        offset_samples = int(strike_idx * spacing * SAMPLE_RATE)
        fundamental = 880.0 + strike_idx * 8.0
        decay = 3.8 + strike_idx * 0.3

        s = generate_bell_strike(
            duration=strike_duration,
            fundamental=fundamental,
            attack_ms=1.5,
            decay_rate=decay,
            noise_duration_ms=8.0,
            noise_amplitude=0.3,
            amplitude=0.85,
            harmonics=bell_harmonics,
        )
        for i, v in enumerate(s):
            target = offset_samples + i
            if target < num_samples:
                combined[target] += v

    combined = normalize(combined)
    combined = apply_fade_out(combined, fade_ms=30.0)
    write_wav(os.path.join(pack_dir, "round_end.wav"), combined)
    write_wav(os.path.join(SOUNDS_DIR, "round_end.wav"), combined)

    # --- session_complete.wav: long sustained bell ---
    print("  classic_bell/session_complete.wav (long sustained bell)")
    primary = generate_bell_strike(
        duration=2.5,
        fundamental=830.0,
        attack_ms=2.0,
        decay_rate=1.5,
        noise_duration_ms=12.0,
        noise_amplitude=0.3,
        amplitude=0.9,
        harmonics=[
            (1.0, 1.0, 1.0),
            (2.0, 0.6, 1.2),
            (2.76, 0.5, 1.5),
            (3.0, 0.35, 1.7),
            (4.07, 0.22, 2.0),
            (5.4, 0.15, 2.5),
            (6.12, 0.1, 3.0),
            (7.3, 0.06, 3.5),
            (8.54, 0.03, 4.0),
        ],
    )
    secondary = generate_bell_strike(
        duration=2.0,
        fundamental=835.0,
        attack_ms=5.0,
        decay_rate=1.8,
        noise_duration_ms=5.0,
        noise_amplitude=0.1,
        amplitude=0.25,
        harmonics=[
            (1.0, 1.0, 1.0),
            (2.0, 0.5, 1.3),
            (2.76, 0.4, 1.6),
            (3.0, 0.25, 2.0),
        ],
    )
    delay_samples = int(0.03 * SAMPLE_RATE)
    for i, v in enumerate(secondary):
        target = i + delay_samples
        if target < len(primary):
            primary[target] += v

    primary = normalize(primary)
    primary = apply_fade_out(primary, fade_ms=50.0)
    write_wav(os.path.join(pack_dir, "session_complete.wav"), primary)
    write_wav(os.path.join(SOUNDS_DIR, "session_complete.wav"), primary)


# ---------------------------------------------------------------------------
# Digital buzzer pack
# ---------------------------------------------------------------------------

def generate_digital_buzzer():
    """Generate the digital_buzzer sound pack (electronic, sharp, punchy)."""
    pack_dir = os.path.join(SOUNDS_DIR, "digital_buzzer")
    os.makedirs(pack_dir, exist_ok=True)

    # --- round_start.wav: short sharp electronic buzz, ~200ms, 800Hz square ---
    print("  digital_buzzer/round_start.wav (sharp electronic buzz)")
    samples = square_wave(800.0, 0.2, amplitude=0.7)
    samples = apply_fade(samples, fade_in_ms=5.0, fade_out_ms=5.0)
    write_wav(os.path.join(pack_dir, "round_start.wav"), samples)

    # --- warning.wav: two rapid electronic chirps, ~300ms total, 1200Hz ---
    print("  digital_buzzer/warning.wav (two rapid chirps)")
    chirp1 = square_wave(1200.0, 0.08, amplitude=0.7)
    chirp1 = apply_fade(chirp1, fade_in_ms=5.0, fade_out_ms=5.0)
    gap = silence(0.06)
    chirp2 = square_wave(1200.0, 0.08, amplitude=0.7)
    chirp2 = apply_fade(chirp2, fade_in_ms=5.0, fade_out_ms=5.0)
    samples = concat(chirp1, gap, chirp2)
    # Pad to ~300ms total
    remaining = int(0.30 * SAMPLE_RATE) - len(samples)
    if remaining > 0:
        samples.extend([0.0] * remaining)
    write_wav(os.path.join(pack_dir, "warning.wav"), samples)

    # --- round_end.wav: three rapid buzzes descending (800, 600, 400Hz), ~400ms ---
    print("  digital_buzzer/round_end.wav (three descending buzzes)")
    buzz1 = square_wave(800.0, 0.08, amplitude=0.7)
    buzz1 = apply_fade(buzz1, fade_in_ms=5.0, fade_out_ms=5.0)
    gap1 = silence(0.04)
    buzz2 = square_wave(600.0, 0.08, amplitude=0.7)
    buzz2 = apply_fade(buzz2, fade_in_ms=5.0, fade_out_ms=5.0)
    gap2 = silence(0.04)
    buzz3 = square_wave(400.0, 0.10, amplitude=0.7)
    buzz3 = apply_fade(buzz3, fade_in_ms=5.0, fade_out_ms=5.0)
    samples = concat(buzz1, gap1, buzz2, gap2, buzz3)
    remaining = int(0.40 * SAMPLE_RATE) - len(samples)
    if remaining > 0:
        samples.extend([0.0] * remaining)
    write_wav(os.path.join(pack_dir, "round_end.wav"), samples)

    # --- session_complete.wav: ascending sweep 400Hz -> 1200Hz, ~600ms ---
    print("  digital_buzzer/session_complete.wav (ascending sweep)")
    samples = sweep(400.0, 1200.0, 0.6, amplitude=0.7)
    samples = apply_fade(samples, fade_in_ms=5.0, fade_out_ms=5.0)
    write_wav(os.path.join(pack_dir, "session_complete.wav"), samples)


# ---------------------------------------------------------------------------
# Minimal beep pack
# ---------------------------------------------------------------------------

def generate_minimal_beep():
    """Generate the minimal_beep sound pack (quiet, subtle sine waves)."""
    pack_dir = os.path.join(SOUNDS_DIR, "minimal_beep")
    os.makedirs(pack_dir, exist_ok=True)

    # --- round_start.wav: single soft sine beep at 880Hz, ~150ms with fade ---
    print("  minimal_beep/round_start.wav (soft sine beep)")
    samples = sine_wave(880.0, 0.15, amplitude=0.7)
    samples = apply_fade(samples, fade_in_ms=5.0, fade_out_ms=20.0)
    write_wav(os.path.join(pack_dir, "round_start.wav"), samples)

    # --- warning.wav: two soft beeps at 660Hz, ~200ms total ---
    print("  minimal_beep/warning.wav (two soft beeps)")
    beep1 = sine_wave(660.0, 0.06, amplitude=0.7)
    beep1 = apply_fade(beep1, fade_in_ms=5.0, fade_out_ms=5.0)
    gap = silence(0.04)
    beep2 = sine_wave(660.0, 0.06, amplitude=0.7)
    beep2 = apply_fade(beep2, fade_in_ms=5.0, fade_out_ms=5.0)
    samples = concat(beep1, gap, beep2)
    remaining = int(0.20 * SAMPLE_RATE) - len(samples)
    if remaining > 0:
        samples.extend([0.0] * remaining)
    write_wav(os.path.join(pack_dir, "warning.wav"), samples)

    # --- round_end.wav: single lower beep at 440Hz, ~200ms ---
    print("  minimal_beep/round_end.wav (low sine beep)")
    samples = sine_wave(440.0, 0.2, amplitude=0.7)
    samples = apply_fade(samples, fade_in_ms=5.0, fade_out_ms=20.0)
    write_wav(os.path.join(pack_dir, "round_end.wav"), samples)

    # --- session_complete.wav: three ascending beeps (440, 660, 880Hz), ~500ms ---
    print("  minimal_beep/session_complete.wav (three ascending beeps)")
    beep1 = sine_wave(440.0, 0.10, amplitude=0.7)
    beep1 = apply_fade(beep1, fade_in_ms=5.0, fade_out_ms=5.0)
    gap1 = silence(0.05)
    beep2 = sine_wave(660.0, 0.10, amplitude=0.7)
    beep2 = apply_fade(beep2, fade_in_ms=5.0, fade_out_ms=5.0)
    gap2 = silence(0.05)
    beep3 = sine_wave(880.0, 0.12, amplitude=0.7)
    beep3 = apply_fade(beep3, fade_in_ms=5.0, fade_out_ms=15.0)
    samples = concat(beep1, gap1, beep2, gap2, beep3)
    remaining = int(0.50 * SAMPLE_RATE) - len(samples)
    if remaining > 0:
        samples.extend([0.0] * remaining)
    write_wav(os.path.join(pack_dir, "session_complete.wav"), samples)


# ---------------------------------------------------------------------------
# Verification
# ---------------------------------------------------------------------------

def verify_all():
    """Verify all generated files are valid WAV and under 500KB."""
    print("\n--- Verification ---")
    all_ok = True

    # Check top-level files
    for filename in SOUND_FILES + ["silence.wav"]:
        filepath = os.path.join(SOUNDS_DIR, filename)
        all_ok &= _verify_file(filepath, allow_silent=(filename == "silence.wav"))

    # Check each pack
    for pack in SOUND_PACKS:
        for filename in SOUND_FILES:
            filepath = os.path.join(SOUNDS_DIR, pack, filename)
            all_ok &= _verify_file(filepath)

    print(f"\n{'All files OK!' if all_ok else 'Some issues detected.'}")
    return all_ok


def _verify_file(filepath: str, allow_silent: bool = False) -> bool:
    """Verify a single WAV file."""
    rel = os.path.relpath(filepath, SOUNDS_DIR)
    if not os.path.exists(filepath):
        print(f"  MISSING: {rel}")
        return False

    size = os.path.getsize(filepath)
    size_kb = size / 1024

    try:
        with wave.open(filepath, "rb") as w:
            channels = w.getnchannels()
            sample_width = w.getsampwidth()
            framerate = w.getframerate()
            frames = w.getnframes()
            duration = frames / framerate

            issues = []
            if channels != 1:
                issues.append(f"channels={channels}")
            if sample_width != 2:
                issues.append(f"sample_width={sample_width}")
            if framerate != 44100:
                issues.append(f"rate={framerate}")
            if size > 500 * 1024:
                issues.append(f"TOO LARGE: {size_kb:.1f}KB")

            raw = w.readframes(frames)
            int_samples = struct.unpack(f"<{frames}h", raw)
            peak_val = max(abs(s) for s in int_samples) if int_samples else 0

            if not allow_silent and peak_val < 100:
                issues.append(f"appears silent (peak={peak_val})")

            status = "OK" if not issues else "ISSUES: " + ", ".join(issues)
            print(f"  {rel}: {duration:.3f}s, {size_kb:.1f}KB, peak={peak_val}, {status}")
            return len(issues) == 0

    except Exception as e:
        print(f"  {rel}: ERROR - {e}")
        return False


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    print(f"Output directory: {SOUNDS_DIR}")
    print(f"Sample rate: {SAMPLE_RATE} Hz, {BITS_PER_SAMPLE}-bit, mono\n")

    # Create pack subdirectories
    for pack in SOUND_PACKS:
        os.makedirs(os.path.join(SOUNDS_DIR, pack), exist_ok=True)

    # Generate classic bell pack (also writes top-level copies)
    print("=== Classic Bell Pack ===")
    generate_classic_bell()

    # Generate digital buzzer pack
    print("\n=== Digital Buzzer Pack ===")
    generate_digital_buzzer()

    # Generate minimal beep pack
    print("\n=== Minimal Beep Pack ===")
    generate_minimal_beep()

    # Ensure silence.wav stays at top level (don't touch it)
    silence_path = os.path.join(SOUNDS_DIR, "silence.wav")
    if os.path.exists(silence_path):
        print(f"\nsilence.wav: preserved at top level ({os.path.getsize(silence_path):,} bytes)")
    else:
        print("\nWARNING: silence.wav not found at top level!")

    verify_all()


if __name__ == "__main__":
    main()

---
paths:
  - "lib/**/audio/**"
  - "lib/**/services/audio*"
  - "lib/**/sound*"
---

# Audio Service Rules

- Pre-load ALL session sound assets before the first round starts. No on-demand loading.
- Configure AudioSession for mixing mode: duck other apps' audio, don't pause them.
- Sounds MUST play even when screen is locked (requires foreground service).
- Sounds MUST be audible over Spotify/Apple Music at reasonable volume.
- Provide volume override option that forces a minimum playback volume.
- Use short, distinct sounds: single bell (round start), double bell (warning), triple bell (round end).
- Release audio resources and stop foreground service when session ends.
- Handle audio interruptions gracefully (phone calls, alarms) - pause session, resume after.
- Sound assets should be lightweight (WAV or OGG, <500KB per sound file).

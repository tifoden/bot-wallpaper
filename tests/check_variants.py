#!/usr/bin/env python3
"""Check that all pre-rendered videos preserve the animation and loop seam."""
import json
import subprocess
import sys
from pathlib import Path

root = Path(sys.argv[1])
names = ("red", "orange", "amber", "green", "teal", "blue", "purple", "pink", "outline")
width, height = 192, 124
frame_bytes = width * height * 3
for name in names:
    video = root / f"{name}.mov"
    probe = json.loads(subprocess.check_output([
        "ffprobe", "-v", "error", "-select_streams", "v:0", "-show_entries", "stream=nb_frames,duration",
        "-of", "json", str(video),
    ]))["streams"][0]
    count = int(probe["nb_frames"])
    if count != 608 or abs(float(probe["duration"]) - 45.6854) > 0.02:
        raise SystemExit(f"Unexpected duration or frame count: {video}")
    raw = subprocess.check_output([
        "ffmpeg", "-v", "error", "-i", str(video), "-vf",
        f"select=eq(n\\,0)+eq(n\\,{count - 1}),scale={width}:{height}",
        "-fps_mode", "passthrough", "-pix_fmt", "rgb24", "-f", "rawvideo", "-",
    ])
    if len(raw) != 2 * frame_bytes:
        raise SystemExit(f"Missing loop frames: {video}")
    diff = sum(abs(a - b) for a, b in zip(raw[:frame_bytes], raw[frame_bytes:])) / frame_bytes
    if diff > 0.15:
        raise SystemExit(f"Loop seam mismatch in {video}: {diff:.4f}")
print("All nine color videos have the expected duration and smooth loop.")

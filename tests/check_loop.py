#!/usr/bin/env python3
"""Check the monochrome wallpaper's loop seam and its final two seconds.

Requires ffmpeg/ffprobe. A cross-fade produces large gray regions that do not
exist in this black-and-white animation, even when the first and last frames match.
"""
import json
import subprocess
import sys
from pathlib import Path

moving_seam = "--moving-seam" in sys.argv
video = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[1] / "resources" / "Grok Bot.mp4"
probe = subprocess.check_output([
    "ffprobe", "-v", "error", "-select_streams", "v:0", "-show_entries",
    "stream=nb_frames", "-of", "json", str(video),
])
count = int(json.loads(probe)["streams"][0]["nb_frames"])
width, height = 320, 208
frame_bytes = width * height

def frames(*args):
    raw = subprocess.check_output([
        "ffmpeg", "-v", "error", *args, "-i", str(video), "-vf",
        "scale=320:208", "-pix_fmt", "gray", "-f", "rawvideo", "-",
    ])
    if len(raw) % frame_bytes:
        raise RuntimeError("Incomplete video frame")
    return [raw[i:i + frame_bytes] for i in range(0, len(raw), frame_bytes)]

seam_raw = subprocess.check_output([
    "ffmpeg", "-v", "error", "-i", str(video), "-vf",
    f"select=eq(n\\,0)+eq(n\\,1)+eq(n\\,{count - 1}),scale=320:208", "-vsync", "0",
    "-pix_fmt", "gray", "-f", "rawvideo", "-",
])
if len(seam_raw) != 3 * frame_bytes:
    raise SystemExit("Could not decode both loop endpoints")
a, next_frame, b = (seam_raw[i * frame_bytes:(i + 1) * frame_bytes] for i in range(3))
next_difference = sum(abs(x - y) for x, y in zip(a, next_frame)) / frame_bytes
mean_difference = sum(abs(x - y) for x, y in zip(a, b)) / frame_bytes
final_frames = frames("-sseof", "-2")
if not final_frames:
    raise SystemExit("Could not decode the end of the video")
max_gray_fraction = max(sum(40 < p < 200 for p in frame) / frame_bytes for frame in final_frames)
print(f"Loop endpoint mean difference: {mean_difference:.4f}/255")
print(f"Maximum midtone fraction near loop: {max_gray_fraction:.4%}")
seam_limit = max(0.1, next_difference * 1.3) if moving_seam else 0.1
if mean_difference > seam_limit or max_gray_fraction > 0.02:
    raise SystemExit("Loop seam mismatch or blended-frame ghosting detected")
print("Loop check passed")

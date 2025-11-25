import time
import random

# Fake files to scan
files = [
    "C:/Windows/System32/kernel32.dll",
    "C:/Users/Luis/Documents/report.docx",
    "C:/Program Files/App/config.cfg",
    "C:/Users/Luis/Desktop/photo.png",
    "C:/Temp/tempfile.tmp",
    "C:/Users/Luis/Music/song.mp3",
    "C:/Users/Luis/Videos/video.mp4",
    "C:/Windows/explorer.exe",
    "C:/Program Files/App/data.db",
]

print("SYSTEM SCAN INITIATED...\n")
time.sleep(1)

for i in range(50):
    file = random.choice(files)
    percent = (i + 1) * 2
    bar = "[" + "#" * (percent // 2) + "-" * (50 - percent // 2) + "]"
    print(f"Scanning: {file}")
    print(f"{bar} {percent}%\n")
    time.sleep(0.1)

print("SCAN COMPLETE ✔")
print("No threats found. Your system is safe.")

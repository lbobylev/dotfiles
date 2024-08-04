import pyperclip
from gtts import gTTS
import os
import time

# Get the text from the clipboard
text = pyperclip.paste()

if text:
    # Create a gTTS object
    tts = gTTS(text=text, lang='en')
    
    # Save the audio file
    audio_file = "clipboard_audio.mp3"
    tts.save(audio_file)
    
    # Play the audio file
    # os.system(f"start {audio_file}")  # For Windows
    os.system(f"afplay {audio_file}")  # For macOS
    # os.system(f"mpg123 {audio_file}")  # For Linux (ensure mpg123 is installed)
    
    # Wait for a moment to allow the audio to play
    #time.sleep(5)
    
    # Optionally, remove the audio file after playing
    #os.remove(audio_file)
else:
    print("Clipboard is empty.")

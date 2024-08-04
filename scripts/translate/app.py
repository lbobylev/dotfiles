from pynput import keyboard
import pyperclip
from openai import OpenAI
import subprocess

client = OpenAI()

def translate_to_english(text):
    response = client.chat.completions.with_raw_response.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "You are a bilingual person and you are asked to translate the following text to English. Don't add any other text, quotes etc, just translate as it is."},
            {"role": "user", "content": f"{text}"}
        ]
    )
    completion = response.parse()
    return str(completion.choices[0].message.content)

# Define the callback function for the hotkey
def on_activate():
    # Get the last item from the clipboard
    clipboard_content = pyperclip.paste()
    print(clipboard_content)
    result = translate_to_english(clipboard_content)
    print(result)
    pyperclip.copy(result)

on_activate()

# # Define the hotkey combination
# hotkey = keyboard.HotKey(
#     keyboard.HotKey.parse('<cmd>+<shift>+m'),
#     on_activate
# )
#
# # Start listening for keyboard events
# def for_canonical(f):
#     return lambda k: f(l.canonical(k))
#
# with keyboard.Listener(
#         on_press=for_canonical(hotkey.press),
#         on_release=for_canonical(hotkey.release)) as l:
#     l.join()


#pip install SpeechRecognition PyAudio
# import speech_recognition as sr
#
# # Initialize the recognizer
# recognizer = sr.Recognizer()
#
# # Use the microphone as the audio source
# with sr.Microphone() as source:
#     print("Please speak something...")
#     audio = recognizer.listen(source)  # Listen for audio
#
#     try:
#         # Recognize speech using Google Web Speech API
#         text = recognizer.recognize_google(audio)
#         print("You said: " + text)
#     except sr.UnknownValueError:
#         print("Sorry, I could not understand the audio.")
#     except sr.RequestError as e:
#         print(f"Could not request results from Google Speech Recognition service; {e}")



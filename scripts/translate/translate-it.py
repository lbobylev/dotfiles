import pyperclip
from openai import OpenAI

client = OpenAI()

def translate(text):
    response = client.chat.completions.with_raw_response.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "You are a bilingual person and you are asked to translate the following text to Italian. Don't add any other text, quotes etc, just translate as it is."},
            {"role": "user", "content": f"{text}"}
        ]
    )
    completion = response.parse()
    return str(completion.choices[0].message.content)

# Get the last item from the clipboard
clipboard_content = pyperclip.paste()
print(clipboard_content)
result = translate(clipboard_content)
print(result)
pyperclip.copy(result)

# import pyaudio
# import wave
# from openai import OpenAI
# import numpy as np
# from gtts import gTTS
# import os
# import webrtcvad
#
# client = OpenAI()
#
# # Настройки аудио
# CHUNK = 2048
# FORMAT = pyaudio.paInt16
# CHANNELS = 1
# RATE = 16000
# THRESHOLD = 1000  # Порог громкости
# SILENCE_DURATION = 2  # Продолжительность тишины для завершения записи
#
# current_dir = os.getcwd()
#
# def alert():
#     os.system("afplay %s/alert.mp3" % current_dir)
#
# def is_silent(data):
#     """Проверяет, является ли текущий фрагмент тихим."""
#     audio_data = np.frombuffer(data, dtype=np.int16)
#     return np.max(audio_data) < THRESHOLD
#
# def is_human_voice(data):
#     # Convert byte data to numpy array
#     audio_data = np.frombuffer(data, dtype=np.int16)
#
#     # Create a VAD instance
#     vad = webrtcvad.Vad()
#
#     # Check if the audio is speech
#     # We need to provide the correct sample rate and ensure the data is in the right format
#     return vad.is_speech(audio_data.tobytes(), RATE)  # Convert to bytes
#
# def record_audio():
#     p = pyaudio.PyAudio()
#     stream = p.open(format=FORMAT, channels=CHANNELS, rate=RATE, input=True, frames_per_buffer=CHUNK)
#
#     print("Listening for speech...")
#     frames = []
#     silent_chunks = 0
#     recording = False
#
#     while True:
#         try:
#             data = stream.read(CHUNK, exception_on_overflow=False)  # Avoid overflow exception
#         except OSError as e:
#             print(f"Error reading audio stream: {e}")
#             continue  # Skip this iteration and try again
#
#         # Check if the data is long enough for VAD processing
#         if len(data) < 320:  # Adjust this based on your sample rate
#             continue
#         
#         if not recording:
#             if is_human_voice(data):
#                 recording = True
#                 print("Recording started...")
#                 frames.append(data)
#         else:
#             frames.append(data)
#             if is_silent(data):
#                 silent_chunks += 1
#             else:
#                 silent_chunks = 0
#
#             if silent_chunks > (SILENCE_DURATION * RATE / CHUNK):
#                 print("Recording stopped.")
#                 alert()
#                 break
#
#     stream.stop_stream()
#     stream.close()
#     p.terminate()
#
#     # Сохранение записи
#     wf = wave.open("output.wav", 'wb')
#     wf.setnchannels(CHANNELS)
#     wf.setsampwidth(p.get_sample_size(FORMAT))
#     wf.setframerate(RATE)
#     wf.writeframes(b''.join(frames))
#     wf.close()
#
#     return "output.wav"
#
# def transcribe_audio(file_path):
#     with open(file_path, "rb") as audio_file:
#         response = client.audio.transcriptions.create(
#                 model = "whisper-1",
#                 file=audio_file,
#                 response_format="text",
#                 language="it"
#                 )
#     return response
#
# def translate(text):
#     response = client.chat.completions.with_raw_response.create(
#         model="gpt-4o-mini",
#         messages=[
#             {"role": "system", "content": "You are a bilingual person and you are asked to translate the following text to Russian. Don't add any other text, quotes etc, just translate as it is."},
#             {"role": "user", "content": f"{text}"}
#         ]
#     )
#     completion = response.parse()
#     return str(completion.choices[0].message.content)
#
# def main():
#     try:
#         while True:
#             audio_file = record_audio()
#             print("Processing...")
#             text = transcribe_audio(audio_file)
#             print("Recognized Text:", text)
#             if not text:
#                 print("No speech detected.")
#                 continue
#
#             translation = translate(text)
#
#             tts = gTTS(text=translation, lang='ru')
#             tts.save("output.mp3")
#
#             # Воспроизведение файла (на Windows)
#             # os.system("start output.mp3")
#             # На MacOS
#             os.system("afplay output.mp3")
#             # На Linux
#             # os.system("mpg123 output.mp3")
#
#     except KeyboardInterrupt:
#         print("\nProgram terminated.")
#
# if __name__ == "__main__":
#     main()

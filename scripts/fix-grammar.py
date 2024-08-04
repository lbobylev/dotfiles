import pyperclip
from openai import OpenAI

client = OpenAI()

def fix_grammar(text):
    response = client.chat.completions.with_raw_response.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "Fix grammar and improve clarity and readability. Make the phrase more natural for a native speaker. Do not add any additional text, quotes, or other elements; just make the necessary corrections. If there are the abbreviations prod/preprod/dev/test in the text, leave them unchanged."},
            {"role": "user", "content": f"{text}"}
        ]
    )
    completion = response.parse()
    return str(completion.choices[0].message.content)

# Get the last item from the clipboard
clipboard_content = pyperclip.paste()
print(clipboard_content)
result = fix_grammar(clipboard_content)
print(result)
pyperclip.copy(result)

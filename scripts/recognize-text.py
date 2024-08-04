from PIL import ImageGrab
from openai import OpenAI
from io import BytesIO
import pyperclip
import base64

client = OpenAI()

screenshot = ImageGrab.grabclipboard()

if screenshot is not None:
    buffer = BytesIO()
    screenshot.save(buffer, format="PNG")
    buffer.seek(0)
    base64_image = base64.b64encode(buffer.read()).decode("utf-8")

    response = client.chat.completions.with_raw_response.create(
        model="gpt-4o-mini",
        messages=[
            {
                "role": "system",
                "content": "Extract text from the image. The text can be in any language. Output the text only. No additional information is needed.",
            },
            {
                "role": "user",
                "content": [
                    {"type": "image_url", "image_url": { "url": f"data:image/png;base64,{base64_image}" }},
                ],
            },
        ],
    )

    result = str(response.parse().choices[0].message.content)
    print(result)
    pyperclip.copy(result)

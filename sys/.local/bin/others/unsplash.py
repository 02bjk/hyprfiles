import requests
import os 

wal = os.path.expandvars(r'$HOME/.cache')
if os.path.isdir(wal):
    os.chdir(wal)
else:
    print(f"{wal} not found")

def random_wal():
        # Your Unsplash Access Key
        ACCESS_KEY = "qX5fxEAxm9A3pHyX4a7ol8lJgg5kIK-7kNkPm0XUCLo"

        # API endpoint for random photo
        url = "https://api.unsplash.com/photos/random"

        # Parameters: you can filter by query or orientation
        params = {
            "query": "wallpaper",       # search term
            "orientation": "landscape", # good for wallpapers
            "count": 1                   # number of images
        }

        # Headers for authentication
        headers = {
            "Authorization": f"Client-ID {ACCESS_KEY}"
        }

        # Make the request
        response = requests.get(url, headers=headers, params=params)

        if response.status_code == 200:
            data = response.json()
            # If count=1, data is a dict; if >1, it's a list
            if isinstance(data, list):
                data = data[0]
            image_url = data["urls"]["full"]
            print("Random wallpaper URL:", image_url)
            img_data = requests.get(image_url).content
            with open("wallpaper.jpg", "wb") as f:
                f.write(img_data)

            print("Wallpaper saved as wallpaper.jpg")
        else:
            print("Error:", response.status_code, response.text)


if __name__ == "__main__":
    random_wal()

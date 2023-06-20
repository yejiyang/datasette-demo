import requests

url = (
    "http://127.0.0.1:8001/datasette-demo/project.json?_labels=on"
)
response = requests.get(url)
print(response.json())

import requests

def callfrida(prompt):
    rjson = {
        "inputs" : str(prompt),
        "parameters": {
            "max_new_tokens": 100
        }, "stream" : False
    }
    res = requests.post("https://fridaplatform.com/generate", json = rjson)
    print(res)
    
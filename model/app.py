
from flask import Flask, request
from threading import Thread
import model
import json
import fridacaller

app = Flask(__name__)

@app.route('/')
def index():
    return 'Hello from Flask!'


@app.route('/prompt', methods=['GET', 'POST'])
def prompt():
    rjson = request.get_json()
    pstr = rjson['prompt']
    fridacaller.callfrida(f"Translate this to spanish: {pstr}")
    d = {"prompt" : str(model.prompt(pstr))}
    return json.dumps(d)

if __name__ == '__main__':
    app.run(debug=True)



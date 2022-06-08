from flask import Flask, Response
import json

app = Flask(__name__)


@app.route("/", methods=['GET'])
def root():
    resp_json = {"status": "banana"}
    return Response(json.dumps(resp_json), status=200, mimetype='application/json')


if __name__ == "__main__":
    port = 6000
    print(" * Rodando na porta: " + str(port))
    app.run(host="0.0.0.0", port=port)

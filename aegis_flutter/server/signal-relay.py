from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

offers = {}
answers = {}
ice_candidates = {}


@app.get("/")
def home():
    return {
        "server": "AEGIS Signaling Server",
        "status": "Running"
    }


# ---------------- OFFER ---------------- #

@app.post("/offer")
def create_offer():
    data = request.json

    peer_id = data["peerId"]

    offers[peer_id] = data["offer"]

    return jsonify({
        "success": True
    })


@app.get("/offer/<peer_id>")
def get_offer(peer_id):
    return jsonify(
        offers.get(peer_id)
    )


# ---------------- ANSWER ---------------- #

@app.post("/answer")
def create_answer():
    data = request.json

    peer_id = data["peerId"]

    answers[peer_id] = data["answer"]

    return jsonify({
        "success": True
    })


@app.get("/answer/<peer_id>")
def get_answer(peer_id):
    return jsonify(
        answers.get(peer_id)
    )


# ---------------- ICE ---------------- #

@app.post("/ice")
def add_ice_candidate():

    data = request.json

    peer_id = data["peerId"]

    if peer_id not in ice_candidates:
        ice_candidates[peer_id] = []

    ice_candidates[peer_id].append(
        data["candidate"]
    )

    return jsonify({
        "success": True
    })


@app.get("/ice/<peer_id>")
def get_ice(peer_id):

    return jsonify(
        ice_candidates.get(peer_id, [])
    )


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=True,
    )
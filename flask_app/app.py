from flask import Flask, request, jsonify

app = Flask(__name__)

def token_required(f):
    def wrapper(*args, **kwargs):
        token = request.headers.get("Authorization", "").replace("Bearer ", "")
        if not token:
            return jsonify({"error": "Missing token"}), 401
        
        # Simple check - if token looks like a JWT (has dots), allow access
        if token.count('.') == 2 and len(token) > 50:
            return f(*args, **kwargs)
        else:
            return jsonify({"error": "Invalid token"}), 403
    
    wrapper.__name__ = f.__name__
    return wrapper

@app.route("/")
def home():
    return jsonify({"msg": "Public access"}), 200

@app.route("/protected")
@token_required
def protected():
    return jsonify({"msg": "You have access to a protected route!"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)






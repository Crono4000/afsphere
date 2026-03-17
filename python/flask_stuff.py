

#import subprocess
import os
from flask import Flask, render_template, send_from_directory, request, jsonify, redirect
from psql_reader import PsqlReader
import subprocess
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

afsphere = os.getenv("AFSPHERE_PATH")
link = "http://127.0.0.1:5000"

os.chdir(afsphere + "/python")

def full_path(pat):
    global afsphere
    return afsphere + pat

app = Flask(__name__,  template_folder=full_path("/html"))
psql = PsqlReader()

limiter = Limiter(
    get_remote_address,
    app=app,
    default_limits=["100 per hour"]
)

@app.route("/upload", methods=["POST"])
def upload_file():
    if not psql.is_token_valid(request.cookies.get("token")):
        return jsonify({"error": "Nenhum ficheiro enviado"}), 400

    if "file" not in request.files or "sphere" not in request.form:
        return jsonify({"error": "Nenhum ficheiro enviado"}), 400

    file = request.files["file"]

    if file.filename == "":
        return jsonify({"error": "Nome de ficheiro vazio"}), 400

    filepath = os.path.join(full_path("/buffer"), file.filename)
    file.save(filepath)

    result = subprocess.run(["afsphere", "add_file_to_sphere", filepath, request.form["sphere"]])
    subprocess.run(["rm", filepath])
    if (result.returncode > 0):
        return jsonify({"error": "Error adding the file to the DB"}), 400

    return jsonify({"message": "Ficheiro recebido", "filename": file.filename})

@app.route("/avaliate_login", methods=["POST"])
@limiter.limit("5 per minute")
def post_login():
    token = psql.login(request.form['username'], request.form['password'])

    if token == None:
        return jsonify({"error": "The password or username are incorrect"}), 400

    return jsonify({"token": token})

@app.route("/")
def home():
    if not psql.is_token_valid(request.cookies.get("token")):
        return redirect("/login")
    return "Olá, Flask!"

@app.route("/login")
def loginPage():
    if psql.is_token_valid(request.cookies.get("token")):
        return redirect("/")
    return render_template("login.html")

@app.route("/sphere/<name>")
def LoadSphere(name):
    token = request.cookies.get("token")
    print(token)
    if not psql.is_token_valid(token):
        return redirect("/login")
    if not psql.check_permission(token, "admin"):
        return redirect("/")
    if not psql.ExistsSphere(name):
        return render_template("no_sphere.html", sphere = name)
    return render_template("show_sphere.html", content = psql.RenderSphereFiles(name), sphere = name)

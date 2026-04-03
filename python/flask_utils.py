

#import subprocess
import os
from flask import Flask, render_template, send_from_directory, request, jsonify, redirect, send_file, make_response
from AfsphereDB import *
import subprocess

afsphere = os.getenv("AFSPHERE_PATH")
link = "https://127.0.0.1:5000"

os.chdir(afsphere + "/python")

def full_path(pat):
    global afsphere
    return afsphere + pat

app = Flask(__name__, template_folder=full_path("/html"))

db = AfsphereDB()

@app.route("/upload", methods=["POST"])
def upload_file():
    if not db.IsTokenValid(request.cookies.get("token")):
        return jsonify({"error": "Nenhum ficheiro enviado"}), 400

    if "file" not in request.files or "sphere" not in request.form:
        return jsonify({"error": "Nenhum ficheiro enviado"}), 400

    file = request.files["file"]

    if file.filename == "":
        return jsonify({"error": "Nome de ficheiro vazio"}), 400
    if db.ExistFile(file.filename):
        return jsonify({"error": "Já existe um ficheiro com esse nome"}), 400 

    data = file.read()
    if not db.IsThereSpace(len(data)):
        return jsonify({"error": "Não ha nenhum disco com espaço suficiente."}), 400 

    db.AddFileToSphere(file.filename, data, request.form["sphere"])
    return jsonify({"message": "Ficheiro recebido", "filename": file.filename})

@app.route("/avaliate_login", methods=["POST"])
def post_login():
    token = db.login(request.form['username'], request.form['password'])

    if token == None:
        return jsonify({"error": "The password or username are incorrect"}), 400

    return jsonify({"token": token})

@app.route("/")
def home():
    if not db.IsTokenValid(request.cookies.get("token")):
        return redirect("/login")
    return "Olá, Flask!"

@app.route("/login")
def loginPage():
    if db.IsTokenValid(request.cookies.get("token")):
        return redirect("/")
    return render_template("login.html")


@app.route("/image/<name>")
def LoadImage(name):
    return send_from_directory(full_path("/images"), name)

@app.route("/sphere/<name>")
def LoadSphere(name):
    token = request.cookies.get("token")
    if not db.IsTokenValid(token):
        return redirect("/login")
    if not db.CheckUserPermission(token, "admin"):
        return redirect("/")
    if not db.ExistSphere(name):
        return render_template("no_sphere.html", sphere = name)
    return render_template("show_sphere.html", content = db.RenderSphereFiles(name), sphere = name)

@app.route("/file/<name>")
def LoadFile(name):
    token = request.cookies.get("token")
    if not db.IsTokenValid(token):
        return redirect("/login")
    if not db.CheckUserPermission(token, "admin"):
        return redirect("/")
    if not db.ExistFile(name):
        return render_template("no_file.html", file = name)

    extension = name.split(".")[len(name.split(".")) - 1]
    if extension == "pdf":
        data = db.ExtractBinaryFileData(name)
        response = make_response(data)
        response.headers['Content-Type'] = 'application/pdf'
        response.headers['Content-Disposition'] = 'inline; filename=%s.pdf' % name
        return response
    return render_template("default_file.html", file = name)

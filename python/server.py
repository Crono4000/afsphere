
#import subprocess
import os
from flask import Flask, render_template, send_from_directory, request, jsonify
from psql_reader import PsqlReader
import subprocess

afsphere = os.getenv("AFSPHERE_PATH")
link = "http://127.0.0.1:5000"

os.chdir(afsphere + "/python")

def full_path(pat):
    global afsphere
    return afsphere + pat

app = Flask(__name__,  template_folder=full_path("/html"))
psql = PsqlReader()

@app.route("/upload", methods=["POST"])
def upload_file():
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

@app.route("/")
def home():
    return "Olá, Flask!"

@app.route("/sphere/<name>")
def LoadSphere(name):
    return render_template("show_sphere.html", content = psql.RenderSphereFiles(name), sphere = name)

if __name__ == "__main__":
    app.run(debug=True)

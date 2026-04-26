
from flask import Flask, render_template, send_from_directory, request, jsonify, redirect, send_file, make_response, Blueprint
from AfsphereTools import *

blueprint_afsphere = Blueprint("blueprint_afsphere", __name__, template_folder=full_path("/html"))

@blueprint_afsphere.route("/image/<name>")
def LoadImage(name):
    return send_from_directory(full_path("/images"), name)

@blueprint_afsphere.route("/sphere/<name>")
def LoadSphere(name):
    if not db.ExistSphere(name):
        return render_template("no_sphere.html", sphere = name)
    return render_template("show_sphere.html", content = db.RenderSphereFiles(name), sphere = name)

@blueprint_afsphere.route("/file/<name>")
def LoadFile(name):
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

@blueprint_afsphere.route("/upload", methods=["POST"])
def upload_file():
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

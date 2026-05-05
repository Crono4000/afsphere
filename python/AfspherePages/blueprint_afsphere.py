
from flask import Flask, render_template, render_template_string, send_from_directory, request, jsonify, redirect, send_file, make_response, Blueprint
from AfsphereTools import *
import markdown

blueprint_afsphere = Blueprint("blueprint_afsphere", __name__, template_folder=full_path("/html"))

@blueprint_afsphere.route("/image/<name>")
def LoadImage(name):
    return send_from_directory(full_path("/images"), name)

@blueprint_afsphere.route("/sphere/<name>")
def LoadSphere(name):
    if not db.ExistSphere(name):
        return render_template("no_sphere.html", sphere = name)
    return render_template("show_sphere.html", content = db.RenderSphereFiles(name), sphere = name)

@blueprint_afsphere.route("/search_spheres")
def LoadSearch():
    search = request.args.get('search')
    if search == None:
        return redirect("/afsphere/search_spheres?search=")
    return render_template("search_sphere.html", content = db.RenderSearchSpheres(search))

@blueprint_afsphere.route("/file/<name>")
def LoadFile(name):
    if not db.ExistFile(name):
        return render_template("no_file.html", file = name)

    extension = name.split(".")[len(name.split(".")) - 1]
    if extension == "pdf":
        data = db.ExtractBinaryFileData(name)
        response = make_response(data)
        response.headers['Content-Type'] = 'application/' + extension
        return response
    if extension == "mp4":
        data = db.ExtractBinaryFileData(name)
        response = make_response(data)
        response.headers['Content-Type'] = 'video/' + extension
        return response
    if extension == "png" or extension == "jpg" or extension == "jpeg" or extension == "webp":
        data = db.ExtractBinaryFileData(name)
        response = make_response(data)
        response.headers['Content-Type'] = 'image/' + extension
        return response
    if extension == "md":
        data = markdown.markdown(db.ExtractTextFileData(name))
        return render_template_string(data)
    if extension == "txt":
        data = "<pre>" + db.ExtractTextFileData(name) + "</pre>"
        return render_template_string(data)
    return render_template("default_file.html", file = name)

@blueprint_afsphere.route("/file_settings/<file_name>")
def LoadFileSettings(file_name):
    if not db.ExistFile(file_name):
        return redirect("/afsphere/search_spheres") 
    return render_template("file_settings.html", file = file_name)

@blueprint_afsphere.route("/download/<file>")
def DownloadFile(file):
    if not db.ExistFile(file):
        return redirect("/afsphere/search_spheres")

    data = db.ExtractBinaryFileData(file)
    response = make_response(data)
    response.headers.set(
        'Content-Disposition',
        'attachment',
        filename=file
    )
    return response

@blueprint_afsphere.route("/change_file_name", methods=["POST"])
def change_file_name():
    if "old_file_name" not in request.form or "new_file_name" not in request.form:
        return jsonify({"error": "Invalid Form"}), 400
    
    if not db.ExistFile(request.form["old_file_name"]):
        return jsonify({"error": "Já existe um ficheiro com esse nome"}), 400 

    if db.ExistFile(request.form["new_file_name"]):
        return jsonify({"error": "Já existe um ficheiro com esse nome"}), 400 
    
    db.Execute("UPDATE file SET file_name = %s WHERE file_name = %s", [request.form["new_file_name"], request.form["old_file_name"]])
    return redirect("/afsphere/file_settings/" + request.form["new_file_name"])

@blueprint_afsphere.route("/change_rank", methods=["POST"])
def change_rank():
    if "sphere" not in request.form or "file" not in request.form or "rank" not in request.form:
        return jsonify({"error": "Invalid Form"}), 400
    
    if not db.ExistFile(request.form["file"]):
          return jsonify({"error": "Não existe ficheiro"}), 400 

    if not db.ExistSphere(request.form["sphere"]):
        return jsonify({"error": "Nao existe a sphere."}), 400

    if not db.EditConnectionRank(request.form["sphere"], request.form["file"], request.form["rank"]):
        return jsonify({"error": "Erro ao dar update no rank."}), 400 
    return redirect("/afsphere/file_settings/" + request.form["file"])

@blueprint_afsphere.route("/connect_file", methods=["POST"])
def connect_file():
    if "sphere" not in request.form or "file" not in request.form or "rank" not in request.form:
        return jsonify({"error": "Invalid Form"}), 400
    
    if not db.ExistFile(request.form["file"]):
          return jsonify({"error": "Não existe ficheiro"}), 400 

    if not db.ExistSphere(request.form["sphere"]):
        return jsonify({"error": "Nao existe a sphere."}), 400

    db.Execute("CALL connect_by_name_rank(%s, %s, %s)", [request.form["file"], request.form["sphere"], request.form["rank"]])
    return redirect("/afsphere/file_settings/" + request.form["file"])

@blueprint_afsphere.route("/delete_file", methods=["POST"])
def delete_file():
    if "file" not in request.form:
        return jsonify({"error": "Invalid Form"}), 400
    
    if not db.ExistFile(request.form["file"]):
          return jsonify({"error": "Não existe ficheiro"}), 400 

    db.Execute("CALL delete_file(%s)", [request.form["file"]])
    return redirect("/afsphere/search_spheres")

@blueprint_afsphere.route("/add_sphere", methods=["POST"])
def add_sphere():
    if "sphere" not in request.form:
        return jsonify({"error": "Invalid Form"}), 400
    
    if db.ExistSphere(request.form["sphere"]):
          return jsonify({"error": "Não existe ficheiro"}), 400 

    db.Execute("INSERT INTO sphere (sphere_name) VALUES (%s)", [request.form["sphere"]])
    return redirect("/afsphere/search_spheres")

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



#import subprocess
import os
from flask import Flask, render_template, send_from_directory, request, jsonify, redirect, send_file, make_response
from AfspherePages import *

os.chdir(full_path("/python"))
app = Flask(__name__, template_folder=full_path("/html"))
app.register_blueprint(blueprint_afsphere, url_prefix="/afsphere")

@app.route("/avaliate_login", methods=["POST"])
def post_login():
    token = db.login(request.form['username'], request.form['password'])

    if token == None:
        return jsonify({"error": "The password or username are incorrect"}), 400

    return jsonify({"token": token})

@app.route("/")
def home():
    return "Olá, Flask!"

@app.route("/login")
def loginPage():
    if db.IsTokenValid(request.cookies.get("token")):
        return redirect("/")
    return render_template("login.html")

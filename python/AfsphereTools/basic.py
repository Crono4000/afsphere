import os
from .AfsphereDB import *

afsphere_path = os.getenv("AFSPHERE_PATH")
link = "https://127.0.0.1:5000"
db = AfsphereDB()

def full_path(pat):
    global afsphere_path
    return afsphere_path + pat


from AfsphereDB import *
import os
import shutil

class AfsphereBuffer():
    def __init__(self, db):
        self.db = db
        self.file_set = set()

        if not os.path.exists("buffer"):
            self.path = "buffer/buffer_0"
        else:
            self.path = "buffer/buffer_" + str(len(os.listdir("buffer")))
        
        os.makedirs(self.path)
    
    def RetrieveFile(self, file):
        origem = self.db.OneExecute("SELECT file_path FROM file WHERE file_name = %s", [file])

        if file in self.file_set:
            return

        shutil.copy2(origem, self.path + "/" + file)
        self.file_set.add(file)
        

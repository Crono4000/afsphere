
import psycopg

class AfsphereDB():
    def __init__(self):
        self.conn = psycopg.connect("host=127.0.0.1 port=5432 dbname=afsphere user=pizzamozzarella password=gotica")

    def Execute(self, query, values):
        with self.conn.cursor() as cur:
            cur.execute(query, values)

            self.conn.commit()
            if cur.description:
                return cur.fetchall()
            return None

    def OneExecute(self, query, values):
        with self.conn.cursor() as cur:
            cur.execute(query, values)

            self.conn.commit()
            if cur.rowcount == 0:
                return None
            return cur.fetchone()[0]

    def Exists(self, query, values):
        with self.conn.cursor() as cur:
            cur.execute("SELECT EXISTS(" + query + ");", values)

            return cur.fetchone()[0]

    def ExistFile(self, file):
        return self.Exists("SELECT file_id FROM file WHERE file_name = %s", [file])

    def ExistSphere(self, file):
        return self.Exists("SELECT sphere_id FROM sphere WHERE sphere_name = %s", [file])

    def close(self):
        self.conn.close()

    # render html pags

    def RenderCustomLine(self, line, vars):
        for gu in range(len(vars)):
            value = vars[gu]
            if value == None:
                value = "Null"
            if isinstance(value, int):
                value = str(value)
            line = line.replace("$" + str(gu), value)
        return line

    def RenderCustomLineTable(self, line, columns, cur):
        result = ""

        result += "<table class=\"table table-striped table-hover\"> <tr>"
        for yu in columns:
            result += "<th>" + yu + "</th>"
        for row in cur:
            result += self.RenderCustomLine(line, row)
        result += "</table>"
        return result

    def RenderTable(self, columns, cur):
        result = ""

        result += "<table class=\"table table-striped table-hover\"> <tr>"
        for yu in columns:
            result += "<th>" + yu + "</th>"
        result += "</tr>"
        for row in cur:
            result += "<tr>"
            for yu in row:
                if isinstance(yu, int):
                    yu = str(yu)
                if yu == None:
                    yu = "Null"
                result += "<td>" + yu + "</td>"
            result += "</tr>"
        result += "</table>"
        return result

    def RenderSimpleTable(self, table, columns):
        query = "SELECT "
        for tt in range(len(columns)):
            if tt != 0:
                query += ", "
            query += columns[tt]
        query += " FROM " + "%s;"
    
        cur = self.Execute(query, [table])
        return self.RenderTable(columns, cur)
        
    def RenderSphereFiles(self, sphere):
        query = "SELECT file.file_id, file_name, rank FROM file, connection, sphere WHERE file.file_id = connection.file_id AND connection.sphere_id = sphere.sphere_id AND sphere_name = %s ORDER BY rank DESC;"
        cur = self.Execute(query, [sphere])

        return self.RenderCustomLineTable("<tr> <td>$0</td> <td><a href=\"/file/$1\" target=\"_blank\">$1</a></td> <td>$2</td> </tr>", ["id", "name", "rank"], cur)

    # managing the accounts

    def CheckToken(self, token):
        query = "SELECT user_id FROM login_session WHERE token = %s;"
        return self.OneExecute(query, [token])

    def CheckUserPermission(self, token, permission):
        user_id = self.CheckToken(token)
        if user_id == None:
            return False

        query = "SELECT * FROM user_permission, permission WHERE user_id = %s AND user_permission.permission_id = permission.permission_id AND permission_name = %s"
        return self.Exists(query, [user_id, permission])     

    def login(self, user, password):
        query = "SELECT login_user(%s, %s);"

        return self.OneExecute(query, [user, password])
    
    def IsTokenValid(self, token):
        if token == None or self.CheckToken(token) == None:
            return False
        else:
            return True

    

    def ExtractBinaryFileData(self, name):
        filepat = self.OneExecute("SELECT file_path FROM file WHERE file_name = %s", [name])
        with open(filepat, "rb") as f:
            data = f.read()

        return data

    def UploadBinaryFileData(self, data, name):
        filepat = self.OneExecute("SELECT file_path FROM file WHERE file_name = %s", [name])
        with open(filepat, "wb") as f:
            f.write(data)

    def IsThereSpace(self, byts):
        return self.Exists("SELECT * FROM disk WHERE disk_used + %s < disk_limit", [byts])

    def AddFileToSphere(self, name, data, sphere):
        self.Execute("CALL add_file_with_sphere(%s, %s, %s);", [name, len(data), sphere])
        self.UploadBinaryFileData(data, name)

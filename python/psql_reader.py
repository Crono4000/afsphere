import psycopg

class PsqlReader():
    def __init__(self):
        self.conn = psycopg.connect("host=127.0.0.1 port=5432 dbname=afsphere user=pizzamozzarella password=gotica")

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
        with self.conn.cursor() as cur:
            query = "SELECT "
            for tt in range(len(columns)):
                if tt != 0:
                    query += ", "
                query += columns[tt]
            query += " FROM " + table + extra + ";"
    
            cur.execute(query)
            return self.RenderTable(columns, cur)
        
    def RenderSphereFiles(self, sphere):
        with self.conn.cursor() as cur:
            query = "SELECT file.file_id, file_name, file_path, rank FROM file, connection, sphere WHERE file.file_id = connection.file_id AND connection.sphere_id = sphere.sphere_id AND sphere_name = '" + sphere + "' ORDER BY rank DESC;"
            cur.execute(query)

            return self.RenderTable(["id", "name", "path", "rank"], cur)
        
    def close(self):
        self.conn.close()
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
            query = "SELECT file.file_id, file_name, rank FROM file, connection, sphere WHERE file.file_id = connection.file_id AND connection.sphere_id = sphere.sphere_id AND sphere_name = %s ORDER BY rank DESC;"
            cur.execute(query, [sphere])

            return self.RenderTable(["id", "name", "rank"], cur)

    def ExistsSphere(self, sphere):
        with self.conn.cursor() as cur:
            query = "SELECT sphere_id FROM sphere WHERE sphere_name = %s;"
            cur.execute(query, [sphere])

            if cur.rowcount == 0:
                return False
            else:
                return True

    def get_token(self, token):
        with self.conn.cursor() as cur:
            query = "SELECT user_id FROM login_session WHERE token = %s;"
            cur.execute(query, [token])

            if cur.rowcount == 0:
                return None
            return cur.fetchone()[0]

    def check_permission(self, token, permission):
        with self.conn.cursor() as cur:
            user_id = self.get_token(token)

            query = "SELECT * FROM user_permission, permission WHERE user_id = %s AND user_permission.permission_id = permission.permission_id AND permission_name = %s;"
            cur.execute(query, [user_id, permission])

            if cur.rowcount == 0:
                return False
            else:
                return True            

    def login(self, user, password):
        with self.conn.cursor() as cur:
            query = "SELECT login_user(%s, %s);"
            cur.execute(query, [user, password])

            self.conn.commit()
            return cur.fetchone()
    
    def is_token_valid(self, token):
        if token == None or self.get_token(token) == None:
            return False
        else:
            return True
    
    def testSqlInjection(self):
        with self.conn.cursor() as cur:
            bar = "10'; SELECT * FROM file WHERE file_name = 'gho.txt"
            cur.execute("SELECT * FROM file WHERE file_name = '%s';", [bar])

            print(cur.fetchall)
        
    def close(self):
        self.conn.close()
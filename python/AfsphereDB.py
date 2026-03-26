
import psycopg

class AfsphereDB():
    def __init__(self):
        self.conn = psycopg.connect("host=127.0.0.1 port=5432 dbname=afsphere user=pizzamozzarella password=gotica")

    def Execute(self, query, values):
        with self.conn.cursor() as cur:
            cur.execute(query, values)

            return cur

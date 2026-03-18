
from server import *

if __name__ == "__main__":
    app.run(debug=True, ssl_context=('/assl/server.crt', '/assl/server.key'))

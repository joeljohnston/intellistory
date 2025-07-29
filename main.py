import http.server
import socketserver
import os

PORT = 8000
DIRECTORY = os.path.abspath(os.getcwd())

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def send_head(self):
        path = self.translate_path(self.path)
        print(f"Requesting: {path} - Exists: {os.path.exists(path)}")  # Debug file existence
        return super().send_head()

with socketserver.TCPServer(("", PORT), CustomHandler) as httpd:
    print(f"Serving at http://localhost:{PORT}")
    httpd.serve_forever()

import sqlite3

conn = sqlite3.connect("login.db")
cursor = conn.cursor()
cursor.execute("""
    CREATE TABLE IF NOT EXISTS usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
    )
""")
# Insertar usuario de prueba
cursor.execute(
    "INSERT OR IGNORE INTO usuario (username, password) VALUES ('andy', '123')"
)
conn.commit()
conn.close()
print("Base de datos y tabla creadas correctamente.")

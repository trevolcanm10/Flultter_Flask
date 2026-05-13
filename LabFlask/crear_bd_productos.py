import sqlite3

conn = sqlite3.connect("mibase.db")
cursor = conn.cursor()

# Tabla usuario
cursor.execute("""
    CREATE TABLE IF NOT EXISTS usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario TEXT NOT NULL UNIQUE,
        clave TEXT NOT NULL
    )
""")
cursor.execute(
    "INSERT OR IGNORE INTO usuario (usuario, clave) VALUES ('admin', 'admin123')"
)

# Tabla tipo_producto
cursor.execute("""
    CREATE TABLE IF NOT EXISTS tipo_producto (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL
    )
""")
tipos = [("Electrónica",), ("Ropa",), ("Alimentos",)]
cursor.executemany("INSERT OR IGNORE INTO tipo_producto (nombre) VALUES (?)", tipos)

# Tabla producto
cursor.execute("""
    CREATE TABLE IF NOT EXISTS producto (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        precio REAL NOT NULL,
        stock INTEGER NOT NULL,
        tipo_producto_id INTEGER,
        FOREIGN KEY (tipo_producto_id) REFERENCES tipo_producto(id)
    )
""")
productos = [
    ("Laptop", 1500.00, 10, 1),
    ("Camiseta", 35.00, 50, 2),
    ("Arroz", 4.50, 200, 3),
]
cursor.executemany(
    "INSERT OR IGNORE INTO producto (nombre, precio, stock, tipo_producto_id) VALUES (?,?,?,?)",
    productos,
)

conn.commit()
conn.close()
print("Base de datos mibase.db creada con datos iniciales.")

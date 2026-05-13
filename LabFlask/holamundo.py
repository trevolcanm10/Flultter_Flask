from flask import Flask, render_template, request, redirect, url_for, session
import sqlite3

app = Flask(__name__)
app.secret_key = "supersecretkey"


def get_db_connection():
    return sqlite3.connect("mibase.db")


@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        usuario = request.form["usuario"]
        clave = request.form["clave"]
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT * FROM usuario WHERE usuario = ? AND clave = ?", (usuario, clave)
        )
        user = cursor.fetchone()
        conn.close()
        if user:
            session["usuario"] = usuario
            return redirect(url_for("principal"))
        else:
            return render_template("login.html", error="Credenciales incorrectas")
    return render_template("login.html")


@app.route("/principal")
def principal():
    if "usuario" not in session:
        return redirect(url_for("login"))
    return render_template("principal.html")


@app.route("/mantenimiento", methods=["GET", "POST"])
def mantenimiento():
    if "usuario" not in session:
        return redirect(url_for("login"))
    conn = get_db_connection()
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    if request.method == "POST":
        id_prod = request.form.get("id")
        nombre = request.form["nombre"]
        precio = request.form["precio"]
        stock = request.form["stock"]
        tipo = request.form["tipo_producto"]

        if id_prod:
            cursor.execute(
                "UPDATE producto SET nombre=?, precio=?, stock=?, tipo_producto_id=? WHERE id=?",
                (nombre, precio, stock, tipo, id_prod),
            )
        else:
            cursor.execute(
                "INSERT INTO producto (nombre, precio, stock, tipo_producto_id) VALUES (?,?,?,?)",
                (nombre, precio, stock, tipo),
            )
        conn.commit()

    # Obtener tipos de producto
    cursor.execute("SELECT * FROM tipo_producto")
    tipos = [dict(row) for row in cursor.fetchall()]

    # Obtener productos con nombre del tipo
    cursor.execute("""
        SELECT p.id, p.nombre, p.precio, p.stock, t.nombre as tipo
        FROM producto p JOIN tipo_producto t ON p.tipo_producto_id = t.id
    """)
    productos = [dict(row) for row in cursor.fetchall()]

    conn.close()
    return render_template("mantenimiento.html", productos=productos, tipos=tipos)


@app.route("/eliminar/<int:id>")
def eliminar(id):
    if "usuario" not in session:
        return redirect(url_for("login"))
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM producto WHERE id = ?", (id,))
    conn.commit()
    conn.close()
    return redirect(url_for("mantenimiento"))


if __name__ == "__main__":
    app.run(debug=True)
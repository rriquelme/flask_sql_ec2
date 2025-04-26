
from flask import Flask, request, render_template_string
import pymysql

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

# Database connection config
db = pymysql.connect(
    host="localhost",
    database="mydatabase",
    user="flask_user",
    password="flask_pass"
)

@app.route("/test/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        name = request.form.get("name")
        email = request.form.get("email")
        
        # Insert into database
        cursor = db.cursor()
        sql = "INSERT INTO users (name, email) VALUES (%s, %s)"
        cursor.execute(sql, (name, email))
        db.commit()
        
        return f"Saved {name} with email {email}!"

    return render_template_string("""
        <form method="post">
            Name: <input type="text" name="name"><br>
            Email: <input type="email" name="email"><br>
            <input type="submit" value="Submit">
        </form>
    """)
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
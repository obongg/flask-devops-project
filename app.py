from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "I am almost a devops engineer — This was created by Obongg"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)


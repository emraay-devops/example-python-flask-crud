#Dockerfile not working properly from a venv perspective. ##TO FIX
FROM python:3.10-bullseye

WORKDIR /code

COPY . .

RUN pip install flask

RUN apt-get update && apt-get install -y python3-venv

RUN python3 -m venv venv

RUN /bin/bash -c "source venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt"

# ENV PATH="/app/venv/bin:$PATH"

# Set environment variable for Flask
# RUN /bin/bash -c "source venv/bin/activate && export FLASK_APP=crudapp.py"

# Initialize, migrate, and upgrade the database
RUN /bin/bash -c "source venv/bin/activate && export FLASK_APP=crudapp.py && flask db init"
RUN /bin/bash -c "source venv/bin/activate && flask db migrate -m 'entries table'"
RUN /bin/bash -c "source venv/bin/activate && flask db upgrade"

# Expose the port the app runs on
EXPOSE 5000

# Run the Flask app
CMD ["/bin/bash", "-c", "source venv/bin/activate && flask run --host=0.0.0.0"]
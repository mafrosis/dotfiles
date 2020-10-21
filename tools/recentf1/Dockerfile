FROM python:3.8

ENV TZ Australia/Melbourne

RUN pip install paho-mqtt

WORKDIR /srv/app
COPY listf1.py ./

CMD ["python", "listf1.py"]

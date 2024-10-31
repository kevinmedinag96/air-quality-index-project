#get base image (amazon linux 2 w/python)
FROM python:3.11.10-alpine3.20


WORKDIR /app

#install third party packages...
COPY ./requirements.txt ./requirements.txt
#RUN pip install --upgrade pip
RUN pip install --no-cache-dir --upgrade -r ./requirements.txt


#COPY ETL files
COPY ./ETL ./ETL

CMD ["python3","ETL/automate-feature-pipeline.py"]



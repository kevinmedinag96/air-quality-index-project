#get base image (amazon linux 2 w/python)
FROM python:3.11.10-alpine3.20



WORKDIR /app

#install third party packages...
COPY ./requirements.txt ./requirements.txt
#RUN pip install --upgrade pip
RUN pip install --no-cache-dir --upgrade -r ./requirements.txt


#COPY ETL files
COPY ./ETL ./ETL

#SET ENVIRONMENT VARIABLES FROM GITHUB ACTION AQI REPO SECRETS
ENV KEVIN_AQICN_KEY= ${KEVIN_AQICN_KEY}
ENV AWS_REGION_NAME= ${AWS_REGION_NAME}
ENV AWS_ACCESS_KEY= ${AWS_ACCESS_KEY}
ENV AWS_SECRET_KEY= ${AWS_SECRET_KEY}
ENV AWS_IAM_ROLE_ARN= ${AWS_IAM_ROLE_ARN}

CMD ["python3","ETL/automate-feature-pipeline.py"]



#get base image (amazon linux 2 w/python)
FROM python:3.11.10-alpine3.20

#environment variables...
ARG KEVIN_AQICN_KEY
ENV KEVIN_AQICN_KEY_2=$KEVIN_AQICN_KEY

ARG AWS_ACCESS_KEY
ENV AWS_ACCESS_KEY_2=$AWS_ACCESS_KEY

ARG AWS_SECRET_KEY
ENV AWS_SECRET_KEY_2=$AWS_SECRET_KEY

ARG AWS_REGION_NAME
ENV AWS_REGION_NAME_2=$AWS_REGION_NAME

ARG AWS_SESSION_TOKEN
ENV AWS_SESSION_TOKEN_2=$AWS_SESSION_TOKEN

WORKDIR /app

#install third party packages...
COPY ./requirements.txt ./requirements.txt

RUN pip install --no-cache-dir --upgrade -r ./requirements.txt

#COPY ETL files
COPY ./ETL ./ETL

CMD ["sh","-c", "python3 ETL/automate-feature-pipeline.py --aqi_token ${KEVIN_AQICN_KEY_2} --aws_acess_key ${AWS_ACCESS_KEY_2} --aws_secret_key ${AWS_SECRET_KEY_2} --aws_session_token ${AWS_SESSION_TOKEN_2} --aws_region ${AWS_REGION_NAME_2}"]





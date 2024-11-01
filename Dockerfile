#get base image (amazon linux 2 w/python)
FROM python:3.11.10-alpine3.20

RUN --mount=type=secret,id=KEVIN_AQICN_KEY,env=KEVIN_AQICN_KEY \
    --mount=type=secret,id=AWS_ACCESS_KEY,env=AWS_ACCESS_KEY \
    --mount=type=secret,id=AWS_SECRET_KEY,env=AWS_SECRET_KEY \
    --mount=type=secret,id=AWS_REGION_NAME,env=AWS_REGION_NAME \
    --mount=type=secret,id=AWS_IAM_ROLE_ARN,env=AWS_IAM_ROLE_ARN

WORKDIR /app

#install third party packages...
COPY ./requirements.txt ./requirements.txt

RUN pip install --no-cache-dir --upgrade -r ./requirements.txt

#COPY ETL files
COPY ./ETL ./ETL

CMD ["python3","ETL/automate-feature-pipeline.py"]



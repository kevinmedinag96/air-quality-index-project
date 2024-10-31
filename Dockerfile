#get base image (amazon linux 2 w/python)
FROM python:3.11.10-alpine3.20

ARG KEVIN_AQICN_KEY=${KEVIN_AQICN_KEY}
ENV KEVIN_AQICN_KEY=${KEVIN_AQICN_KEY}

ARG AWS_ACCESS_KEY=${AWS_ACCESS_KEY}
ENV AWS_ACCESS_KEY=${AWS_ACCESS_KEY}

ARG AWS_SECRET_KEY=${AWS_SECRET_KEY}
ENV AWS_SECRET_KEY=${AWS_SECRET_KEY}

ARG AWS_REGION_NAME=${AWS_REGION_NAME}
ENV AWS_REGION_NAME=${AWS_REGION_NAME}

ARG AWS_IAM_ROLE_ARN=${AWS_IAM_ROLE_ARN}
ENV AWS_IAM_ROLE_ARN=${AWS_IAM_ROLE_ARN}


WORKDIR /app

#install third party packages...
COPY ./requirements.txt ./requirements.txt
#RUN pip install --upgrade pip
RUN pip install --no-cache-dir --upgrade -r ./requirements.txt


#COPY ETL files
COPY ./ETL ./ETL

CMD ["python3","ETL/automate-feature-pipeline.py"]



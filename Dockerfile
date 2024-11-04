#get base image (amazon linux 2 w/python)
FROM python:3.11.10-alpine3.20

#environment variables...
#ARG KEVIN_AQICN_KEY
#ENV KEVIN_AQICN_KEY_2=$KEVIN_AQICN_KEY

#ARG AWS_ACCESS_KEY
#ENV AWS_ACCESS_KEY_2=$AWS_ACCESS_KEY

#ARG AWS_SECRET_KEY
#ENV AWS_SECRET_KEY_2=$AWS_SECRET_KEY

#ARG AWS_REGION_NAME
#ENV AWS_REGION_NAME_2=$AWS_REGION_NAME

#ARG AWS_IAM_ROLE_ARN
#ENV AWS_IAM_ROLE_ARN_2=$AWS_IAM_ROLE_ARN

#RUN --mount=type=secret,id=KEVIN_AQICN_KEY,env=KEVIN_AQICN_KEY \
#    --mount=type=secret,id=AWS_ACCESS_KEY,env=AWS_ACCESS_KEY \
#    --mount=type=secret,id=AWS_SECRET_KEY,env=AWS_SECRET_KEY \
#    --mount=type=secret,id=AWS_REGION_NAME,env=AWS_REGION_NAME \
#    --mount=type=secret,id=AWS_IAM_ROLE_ARN,env=AWS_IAM_ROLE_ARN 

#echo --token-from-env $KEVIN_AQICN_KEY
#--mount=type=secret,id=AWS_ACCESS_KEY \
#--mount=type=secret,id=AWS_SECRET_KEY \
#--mount=type=secret,id=AWS_REGION_NAME \
#--mount=type=secret,id=AWS_IAM_ROLE_ARN

#RUN echo "testing..."

#RUN ls -la /home/runner/work/_temp/docker-actions-toolkit-26Y4tD/

#RUN echo $KEVIN_AQICN_KEY



#Run echo "end testing..."
WORKDIR /app

#install third party packages...
COPY ./requirements.txt ./requirements.txt

RUN pip install --no-cache-dir --upgrade -r ./requirements.txt

#COPY ETL files
COPY ./ETL ./ETL

CMD ["python3","ETL/automate-feature-pipeline.py"]



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

#ARG AWS_SESSION_TOKEN
#ENV AWS_SESSION_TOKEN_2=$AWS_SESSION_TOKEN


RUN --mount=type=secret,id=KEVIN_AQICN_KEY,target=/run/secrets/id
RUN --mount=type=secret,id=AWS_ACCESS_KEY,target=/run/secrets/id 
RUN --mount=type=secret,id=AWS_SECRET_KEY,target=/run/secrets/id 
RUN --mount=type=secret,id=AWS_REGION_NAME,target=/run/secrets/id 
RUN --mount=type=secret,id=AWS_SESSION_TOKEN,target=/run/secrets/id

#echo --token-from-env $KEVIN_AQICN_KEY
#--mount=type=secret,id=AWS_ACCESS_KEY \
#--mount=type=secret,id=AWS_SECRET_KEY \
#--mount=type=secret,id=AWS_REGION_NAME \
#--mount=type=secret,id=AWS_IAM_ROLE_ARN

RUN echo "testing..."

#RUN ls -la /home/runner/work/_temp/docker-actions-toolkit-26Y4tD/

RUN ls -la $HOME/root
RUN ls -la /run/
RUN ls -la $HOME/runner/work/_temp/docker-actions-toolkit-6IqCSz/




Run echo "end testing..."
WORKDIR /app

#install third party packages...
COPY ./requirements.txt ./requirements.txt

RUN pip install --no-cache-dir --upgrade -r ./requirements.txt

#COPY ETL files
COPY ./ETL ./ETL

CMD ["sh","-c", "python3 ETL/automate-feature-pipeline.py --aqi_token ${KEVIN_AQICN_KEY_2} --aws_acess_key ${AWS_ACCESS_KEY_2} --aws_secret_key ${AWS_SECRET_KEY_2} --aws_session_token ${AWS_SESSION_TOKEN_2} --aws_region ${AWS_REGION_NAME_2} --role_to_assume ${AWS_ROLE_TO_ASSUME_2} --role_session_name ${AWS_ROLE_SESSION_NAME_2}"]





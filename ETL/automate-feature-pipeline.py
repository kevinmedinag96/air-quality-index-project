import requests
from datetime import datetime
import pytz
import boto3
from decimal import Decimal
from pydantic import BaseModel
import os
import argparse
from loguru import logger


geolocs = {
    "Mexico City" : (19.432608,-99.133209), #latitude, longitude
    "Monterrey" : (25.686613, -100.316116),
    "Guadalajara" : (20.659698, -103.349609)
}
    
class AqiInput(BaseModel):
    Location: str
    Token: str
    
    


def air_quality_index_feature_pipeline(input_aqicn : AqiInput):
    #use HTTP to request data from aqicn API
    #Extract...
    lat,long = geolocs[input_aqicn.Location]

    response= requests.get(
        url=f"https://api.waqi.info/feed/geo:{lat};{long}/",
        params={
            "token": input_aqicn.Token
        }
    ).json()
    
    #Transform...
    saved_cols = ["co","no2","pm10","pm25","o3","so2"]
    pollutants = response["data"]["iaqi"]
    #print(f"response : {response}")
    #print(pollutants)

    for k in pollutants.keys():
        pollutants[k] = round(Decimal(pollutants[k]["v"]),3)
        

    data_json = {}
    for name in saved_cols:
        if name in pollutants:
            data_json[name] = pollutants[name]

    data_json["datetime"] = datetime.now(pytz.timezone("America/Mexico_City")).strftime("%d/%m/%Y, %H:%M:%S") 
    
    data_json["location"] = input_aqicn.Location 

    logger.info(data_json)

    logger.info("setting dynamodb resource..")

    logger.info(f"access key : {os.environ['AWS_ACCESS_KEY_2']}\nsecret key: {os.environ['AWS_SECRET_KEY_2']}\nsession-token :{os.environ['AWS_SESSION_TOKEN_2']}")

    session = boto3.session.Session(
        aws_access_key_id= os.environ["AWS_ACCESS_KEY_2"],
        aws_secret_access_key=os.environ["AWS_SECRET_KEY_2"],
        aws_session_token=os.environ["AWS_SESSION_TOKEN_2"],
        region_name= os.environ["AWS_REGION_NAME_2"]
    )

    logger.info(f"credentials from session : {session.get_credentials()}")

    dynamodb = session.resource("dynamodb")

    logger.info("putting items in table..")

    table = dynamodb.Table('AirQualityIndexRecords')

    data_json["id"] = table.scan()["Count"]

    #Load...
    table.put_item(
        Item=data_json
    ) 

    logger.info("Done...")
    

   

    

def construct_input(loc: str, token : str):
    #this data class contains the data variables which will be used to extract,transform,load data from aqicn.org
    return AqiInput(Location=loc, Token = token)

if __name__ == "__main__":
    
    #iterate through each geolocation to apply the ETL
    for k in geolocs.keys():
        loc = k
        aqicn_token = os.environ["KEVIN_AQICN_KEY_2"] #personal use

        logger.info(f"aqicn key: {aqicn_token}")
        aqicn_input = construct_input(loc,aqicn_token)
        air_quality_index_feature_pipeline(aqicn_input)
import requests
from datetime import datetime
import pytz
import boto3
from decimal import Decimal
from pydantic import BaseModel
import os


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
    print(f"response : {response}")
    print(pollutants)

    for k in pollutants.keys():
        pollutants[k] = round(Decimal(pollutants[k]["v"]),3)
        

    data_json = {}
    for name in saved_cols:
        if name in pollutants:
            data_json[name] = pollutants[name]

    data_json["datetime"] = datetime.now(pytz.timezone("America/Mexico_City")).strftime("%d/%m/%Y, %H:%M:%S")
    
    data_json["location"] = input_aqicn.Location

    # get boto3 dynamoDB client for desired table
    #dynamodb = boto3.resource('dynamodb')
    """ session = IAMRolesAnywhereSession(
        #profile_arn="arn:aws:rolesanywhere:eu-central-1:************:profile/a6294488-77cf-4d4a-8c5c-40b96690bbf0",
        role_arn="arn:aws:iam::982534381087:role/service-role/SageMaker-DataScientist2",
        #trust_anchor_arn="arn:aws:rolesanywhere:eu-central-1::************::trust-anchor/4579702c-9abb-47c2-88b2-c734e0b29539",
        #certificate='certificate.pem',
        #private_key='privkey.pem',
        region="us-east-1"
    ).get_session() """

    #get hard-coded aws credentials from AWS IAM user kevin-access-user

    #session = boto3.Session(
    #    aws_access_key_id=os.environ["AWS_ACCESS_KEY_2"],
    #    aws_secret_access_key= os.environ["AWS_SECRET_KEY_2"],
    #    region_name="us-east-1"
    #)

    #print(f"access key :{os.environ['AWS_ACCESS_KEY_2']}")
    #print(f"secret key :{os.environ['AWS_SECRET_KEY_2']}")
    #print(f"region name :{os.environ['AWS_REGION_NAME_2']}")
    #print(f"role arn: {os.environ['AWS_IAM_ROLE_ARN_2']}")

    #get temporary access credentials...
    """ print("hey...")
    sts_client = boto3.client("dynamodb")#session.client("sts")
    print("yo...")
    

    response = sts_client.assume_role(
        RoleArn="arn:aws:iam::982534381087:role/kevin-aqi-proj-role",#os.environ["AWS_IAM_ROLE_ARN_2"],
        RoleSessionName="kevin-store-aqi-session"
    )
    print(response)

    #manipulate dynamodb desired table...
    new_session = boto3.Session(aws_access_key_id=response['Credentials']['AccessKeyId'],
                      aws_secret_access_key=response['Credentials']['SecretAccessKey'],
                      aws_session_token=response['Credentials']['SessionToken'],
                      region_name="us-east-1")

    dynamodb = new_session.resource("dynamodb") """
    print("setting dynamodb client..")
    dynamodb = boto3.resource("dynamodb",region="us-east-1")#boto3.client("dynamodb",region_name="us-east-1")

    print("getting dynamodb table..")

    table = dynamodb.Table('AirQualityIndexRecords')

    data_json["id"] = table.scan()["Count"]

    #Load...
    table.put_item(
        Item=data_json
    ) 

    print("Done...")
    

   

    

def construct_input(loc: str, token : str):
    #this data class contains the data variables which will be used to extract,transform,load data from aqicn.org
    return AqiInput(Location=loc, Token = token)

if __name__ == "__main__":
    #iterate through each geolocation to apply the ETL
    for k in geolocs.keys():
        loc = k
        #aqicn_token = os.environ["KEVIN_AQICN_KEY_2"] #personal use
        aqicn_token = "4160d19c73429aaee7d89467b128c082b3c6b868"

        print(f"aqicn key: {aqicn_token}")
        aqicn_input = construct_input(loc,aqicn_token)
        air_quality_index_feature_pipeline(aqicn_input)
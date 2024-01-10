import requests

def lambda_handler(event, context):
    print(event)
    res = requests.get('https://www.google.com')
    print(res.status_code)
    return {'message' : 'Hello World From Python Lambda'}
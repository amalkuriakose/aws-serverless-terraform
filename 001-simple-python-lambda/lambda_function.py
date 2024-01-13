def lambda_handler(event, context):
    print(event)
    return {'message' : 'Hello World From Python Lambda'}
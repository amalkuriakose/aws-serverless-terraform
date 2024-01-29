def lambda_handler(event, context):
    for record in event['Records']:
        print(record)
    return {'message' : 'SQS messages processed successfully'}
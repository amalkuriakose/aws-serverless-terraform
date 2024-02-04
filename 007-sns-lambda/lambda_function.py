def lambda_handler(event, context):
    message = event['Records'][0]['Sns']['Message']
    print("SNS Message: " + message)
    return {'message' : 'SNS message processed successfully'}
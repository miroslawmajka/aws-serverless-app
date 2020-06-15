import json


def helloHandler(event, context):
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({
            'success': True,
            'message': 'DUMMY PYTHON RESPONSE'
        })
    }

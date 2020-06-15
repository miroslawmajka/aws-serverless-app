class LambdaResponse {
    constructor(body) {
        this.statusCode = 200;
        this.headers = {
            'Access-Control-Allow-Origin': '*'
        };
        this.body = body;
    }
}

module.exports = LambdaResponse;

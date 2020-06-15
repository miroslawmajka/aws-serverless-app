class LambdaResponse {
    constructor(message) {
        this.statusCode = 200;
        this.headers = {
            'Access-Control-Allow-Origin': '*'
        };
        this.body = JSON.stringify({
            success: true,
            message
        });
    }
}

module.exports = LambdaResponse;

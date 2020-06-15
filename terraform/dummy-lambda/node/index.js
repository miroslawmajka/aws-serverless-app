async function dummyHandler(event) {
    return {
        statusCode: 200,
        headers: {
            'Access-Control-Allow-Origin': '*'
        },
        body: JSON.stringify('DUMMY NODE RESPONSE')
    };
}

exports.helloHandler = dummyHandler;
exports.lotteryHandler = dummyHandler;

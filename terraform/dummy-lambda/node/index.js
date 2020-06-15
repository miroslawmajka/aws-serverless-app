async function dummyHandler(event) {
    return {
        statusCode: 200,
        headers: {
            'Access-Control-Allow-Origin': '*'
        },
        body: JSON.stringify({
            success: true,
            message: 'DUMMY NODE RESPONSE'
        })
    };
}

exports.helloHandler = dummyHandler;
exports.lotteryHandler = dummyHandler;

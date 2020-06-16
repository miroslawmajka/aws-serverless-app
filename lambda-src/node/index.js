/**
 * Entry point for all Node Lambda handlers
 */
const lotteryNumbersHandler = require('./lib/handlers/lottery-numbers-handler');

const LambdaResponse = require('./lib/model/lambda-response');

async function helloHandler() {
    return new LambdaResponse('Hello from Lambda Node!');
}

async function lotteryHandler() {
    return new LambdaResponse(lotteryNumbersHandler.handle());
}

exports.helloHandler = helloHandler;
exports.lotteryHandler = lotteryHandler;

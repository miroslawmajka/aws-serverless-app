/**
 * Entry point for all Node Lambda handlers
 */

const lotteryPresentationHandler = require('./lib/handlers/lottery-presentation-handler');

const LambdaResponse = require('./lib/model/lambda-response');

async function helloHandler() {
    return new LambdaResponse('Hello from Lambda Node!');
}

async function lotteryHandler() {
    return new LambdaResponse(lotteryPresentationHandler.handle());
}

exports.helloHandler = helloHandler;
exports.lotteryHandler = lotteryHandler;

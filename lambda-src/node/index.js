/**
 * Entry point for all Node Lambda handlers
 */

const LambdaResponse = require('./lib/model/lambda-response');

async function helloHandler() {
    return new LambdaResponse('Hello from Lambda Node!');
}

async function lotteryHandler() {
    return new LambdaResponse('TODO: random lottery numbers');
}

exports.helloHandler = helloHandler;
exports.lotteryHandler = lotteryHandler;

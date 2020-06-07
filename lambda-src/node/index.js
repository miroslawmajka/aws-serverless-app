/**
 * Entry point for all Node Lambda handlers
 */
 
const LambdaResponse = require('./lib/model/lambda-response');

async function handler() {
    return new LambdaResponse(JSON.stringify('Hello from Lambda Node!'));
}

async function lotteryHandler() {
    return new LambdaResponse(JSON.stringify('TODO: random lottery numbers'));
}

exports.handler = handler;
exports.lotteryHandler = lotteryHandler;

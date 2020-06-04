/**
 * Entry point for all Node Lambda handlers
 */
 
const LambdaResponse = require('./lib/model/lambda-response');

async function handler() {
    return new LambdaResponse(JSON.stringify('Actual Node function'));
}

async function lotteryHandler() {
    return new LambdaResponse(JSON.stringify('Random lottery numbers'));
}

exports.handler = handler;
exports.lotteryHandler = lotteryHandler;

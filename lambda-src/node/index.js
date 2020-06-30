/**
 * Entry point for all Node Lambda handlers
 */

const LotteryPresentation = require('./lib/handlers/lottery-presentation-handler');
const LotteryNumbers = require('./lib/handlers/lottery-numbers-handler');
const LambdaResponse = require('./lib/model/lambda-response');

async function helloHandler() {
    return new LambdaResponse('Hello from Lambda Node!');
}

async function lotteryHandler() {
    const lotteryNumbers = new LotteryNumbers();
    const lotteryPresentation = new LotteryPresentation();

    const numbers = lotteryNumbers.handle();
    const response = lotteryPresentation.handle(numbers);

    return new LambdaResponse(response);
}

exports.helloHandler = helloHandler;
exports.lotteryHandler = lotteryHandler;

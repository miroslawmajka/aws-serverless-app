function handle(lotteryNumbersHandler = require('./lottery-numbers-handler')) {
    const numbers = lotteryNumbersHandler.handle();
    const text = `${numbers.slice(0, 5).join(' ')} [${numbers[5]}]`;

    return {
        numbers,
        text
    };
}

module.exports = {
    handle
};

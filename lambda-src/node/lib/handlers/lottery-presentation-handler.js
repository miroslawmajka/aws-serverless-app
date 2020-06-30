class LotteryPresentation {
    handle(numbers) {
        const text = `${numbers.slice(0, 5).join(' ')} [${numbers[5]}]`;

        return {
            numbers,
            text
        };
    }
}

module.exports = LotteryPresentation;

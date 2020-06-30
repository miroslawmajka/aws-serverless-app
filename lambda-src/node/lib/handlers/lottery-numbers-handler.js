class LotteryNumbers {
    handle() {
        let lotteryNumbers = [];

        while (lotteryNumbers.length < 5) {
            const numberCandidate = Math.floor(Math.random() * 47) + 1;

            if (!lotteryNumbers.includes(numberCandidate)) lotteryNumbers.push(numberCandidate);
        }

        lotteryNumbers = lotteryNumbers.sort((a, b) => a - b);

        const lifeBall = Math.floor(Math.random() * 10) + 1;

        lotteryNumbers.push(lifeBall);

        return lotteryNumbers;
    }
}

module.exports = LotteryNumbers;

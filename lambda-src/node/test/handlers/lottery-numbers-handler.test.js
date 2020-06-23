const expect = require('chai').expect;

const subject = require('../../lib/handlers/lottery-numbers-handler');

const LOTTERY_ITERATIONS = 100;

describe(`When I call the lottery numbers handler ${LOTTERY_ITERATIONS} times`, function () {
    for (let i = 0; i < LOTTERY_ITERATIONS; i++) {
        describe(`In iteration ${i}`, function () {
            it('I get a sorted array with 5 random unique numbers from 1 to 47 and 1 life ball number from 1 to 10', function () {
                const actual = subject.handle();

                expect(actual).to.be.an('array');
                expect(actual).to.have.lengthOf(6);

                const numberOne = actual[0];
                const numberTwo = actual[1];
                const numberThree = actual[2];
                const numberFour = actual[3];
                const numberFive = actual[4];

                expect(numberOne).to.be.an('number');
                expect(numberTwo).to.be.an('number');
                expect(numberThree).to.be.an('number');
                expect(numberFour).to.be.an('number');
                expect(numberFive).to.be.an('number');

                expect(numberTwo).to.be.above(numberOne);
                expect(numberThree).to.be.above(numberTwo);
                expect(numberFour).to.be.above(numberThree);
                expect(numberFive).to.be.above(numberFour);

                const lifeBall = actual[5];

                expect(lifeBall).to.be.an('number');

                expect(lifeBall).to.be.at.least(1);
                expect(lifeBall).to.be.at.most(10);
            });
        });
    }
});

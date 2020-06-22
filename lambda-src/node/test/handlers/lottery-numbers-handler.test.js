const expect = require('chai').expect;

const subject = require('../../lib/handlers/lottery-numbers-handler');

describe('When I call the lottery numbers handler', function () {
    it('Then I get a sorted array with 5 random non-repeating numbers between 1 and 47 and 1 number between 1 and 10', function () {
        const actual = subject.handle();

        expect(actual).to.be.an('array');
        expect(actual).to.have.lengthOf(6);

        const numberOne = actual[0];
        const numberTwo = actual[1];
        const numberThree = actual[2];
        const numberFour = actual[3];
        const numberFive = actual[4];

        expect(numberTwo).to.be.above(numberOne);
        expect(numberThree).to.be.above(numberTwo);
        expect(numberFour).to.be.above(numberThree);
        expect(numberFive).to.be.above(numberFour);

        const lifeBall = actual[5];

        expect(lifeBall).to.be.at.least(1);
        expect(lifeBall).to.be.at.most(10);
    });
});

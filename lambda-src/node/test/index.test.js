const expect = require('chai').expect;

const subject = require('../index');

describe('When I call lambda handlers', function () {
    it('Then I get a hello mesage from the hello handler', async function () {
        const actual = await subject.helloHandler();

        expect(actual).to.be.an('object');
    });

    it('Then I get numbers from the lottery handler', async function () {
        const actual = await subject.lotteryHandler();

        expect(actual).to.be.an('object');
    });
});

const chai = require('chai');
const should = chai.should();

const subject = require('../index');

describe('When I call lambda handlers', function () {
    it('Then I get a hello mesage from the hello handler', function () {
        const actual = subject.helloHandler();

        should.exist(actual);
    });

    it('Then I get numbers from the lottery handler', function () {
        const actual = subject.lotteryHandler();

        should.exist(actual);
    });
});

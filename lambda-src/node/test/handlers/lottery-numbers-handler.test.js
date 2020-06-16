const chai = require('chai');
const should = chai.should();

const subject = require('../../lib/handlers/lottery-numbers-handler');

describe('When I call the lottery handle', function () {
    it('Then I get a sorted array with 6 random non-repeating numbers', function () {
        const actual = subject.handle();

        should.exist(actual);
    });
});

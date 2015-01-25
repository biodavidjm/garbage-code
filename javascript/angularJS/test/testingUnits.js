
// Very basic test to check that unit testing works.

describe('A very simple test', function() {
  var a;

  it('This is the test', function() {
    a = true;

    expect(a).toBe(true);
  });
});

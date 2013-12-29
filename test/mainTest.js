var foo;

foo = this.foo;

describe("foo", function() {
  return it("exists", function() {
    return expect(foo).toBeDefined();
  });
});

// require("helpers/some_helpers.js");

describe("<%= name %>", function(){
  setup(function(){
    JaySmock.extend(this);
  });

  it("should be implemented", function(){ with(this) {
    fail("Implement me");
  }});

  describe("another thing to do", function(){
    it("should be implemented as well", function(){ with(this) {
      fail("Implement me");
    }});
  });
});

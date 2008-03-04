require("../../public/javascripts/strac.js");

describe('Strac.Login.Form', function(){
  setup(function(){
    JaySmock.extend(this);
  });
  
  describe("#constructor", function(){
    it("expands the login form and assigns it the login_form property", function(){ with(this){
      var form = createMock("login form");
      var expandedLoginForm = createMock("expanded login form");
      window.mockExpect('$').withArgs(form).returns(expandedLoginForm);
      var form = new Strac.Login.Form(form);
      assertEqual(expandedLoginForm, form.login_form);
    }});
  });

  describe('#toggle', function(){
    it("toggles the login form's visiblity", function(){ with(this){
      var form = createMock("login form");
      form.expects('toggle');
      new Strac.Login.Form(form).toggle();
    }});
  });
});

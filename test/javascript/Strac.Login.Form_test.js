require("../../public/javascripts/strac.js");
// 
describe("Strac.Login.Form constructor", {
  setup: function(options) {
    JaySmock.extend(this);
  },
  
  "#constructor takes and expands the login form": function(){ with(this) {
    var form = createMock("login form");
    window.mockExpect('$').withArgs(form);
    new Strac.Login.Form(form);    
  }}
});

// describe("Strac.Login.Form#toggle", {
//   "#toggle toggles the login form's visiblity": function() { with(this) {
//     var form = createMock("login form");
//     form.expects('toggle');
//     new Strac.Login.Form(form).toggle();
//   }},
//   
// });
// 
describe("Strac.Login.Form", function(){
  this.setup = function(options) {
    JaySmock.extend(this);
  };
  
  describe("#toggle", function(){
    this.setup = function(options){
      this.foo = "FOO";
    };
    
    describe("default behavior", {
      "should toggle the visibility of the login form": function(){ with(this){
        var form = createMock("login form");
        form.expects('toggle');
        new Strac.Login.Form(form).toggle();
        assertEqual("FOO", foo);
      }}
    })
  });
  

  describe("#toggle when the login form is not visible", {
    setup: function(options) {
      this.bar = "BAR";
    },
    
    "should toggles the visibility of the login form": function(){ with(this){
      var form = createMock("login form");
      form.expects('toggle');
      new Strac.Login.Form(form).toggle();
      assertEqual("BAR", bar);
      assertEqual("FOOmanchu", foo);
    }},    
  })
 });

/*
toggleLoginAndSignupVisibility: function(){
  var login_form_container = $('login_form_container');
  var signup_form_container = $('signup_form_container')
  login_form_container.toggle();
  signup_form_container.toggle();
  var form = login_form_container;
  if(signup_form_container.visible()){
    form = signup_form_container;
  }
  form.down('form').focusFirstElement();  
},


var login_form = new Strac.Login.Form($("login_form_container"));
var signup_form = new Strac.Signup.Form($("signup_form_container"));
Strac.loginAndSignupForm = Strac.Utilities.FormToggler(login_form, signup_form);
Strac.loginAndSignupForm.toggleWithFirstElementFocus();

function toggle(){
  this.login_form.toggle();
  this.signup_form.toggle();
}

*/

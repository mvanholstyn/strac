var Strac = {};
Object.extend(Strac, {
  toggleLoginAndSignupVisibility: function(){
    var login_form_container = $('login_form_container');
    var signup_form_container = $('signup_form_container')
    login_form_container.toggle();
    signup_form_container.toggle();
    var form = login_form_container;
    if(signup_form_container.visible()){
      form = signup_form_container;
    }
    form.getElementsBySelector('form input[type=text]')[0].focus();  
  }
});
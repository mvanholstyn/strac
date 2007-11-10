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
    form.down('form').focusFirstElement();  
  },
  
  // This inserts <a class="close"><span></span></a> into the passed in element
  setupCloseButtonForElement: function(element){
    var anchor = document.createElement("a");
    anchor.addClassName("close");
    anchor.appendChild(document.createElement("span"));
    element.insertBefore(anchor, element.firstChild);
    
    var close = element.down('a');  
    close.observe('click', function(){
      element.hide();
    });
    close.observe("mouseover", function(){
      close.down("span").setStyle({visibility: 'visible'});
    });  
    close.observe("mouseout", function(){
      close.down("span").setStyle({visibility: 'hidden'});
    });  
  }
});


/* Window Load Events */
Event.observe(window, 'load', function(){
  Strac.setupCloseButtonForElement($('notice'));
  Strac.setupCloseButtonForElement($('error'));
});

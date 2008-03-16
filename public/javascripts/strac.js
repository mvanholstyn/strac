var Strac = {};

Strac.Login = {};
Strac.Login.Form = Class.create();
Strac.Login.Form.prototype = {
  initialize: function(form){
    this.login_form = $(form);
  },
  
  toggle: function(){
    this.login_form.toggle();
  }
};

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
    if(element){
      var anchor = document.createElement("a");
      anchor.addClassName("close");
      anchor.appendChild(document.createElement("span"));
      element.insertBefore(anchor, element.firstChild);
    
      var close = element.down('a');  
      close.observe('click', function(){
        element.hide();
      });
      element.observe("mouseover", function(){
        close.down("span").setStyle({visibility: 'visible'});
      });  
      element.observe("mouseout", function(){
        close.down("span").setStyle({visibility: 'hidden'});
      });  
    }
  }
});

/* Project Stats */
Strac.ProjectStats = new Object();
Object.extend(Strac.ProjectStats, {
  averageVelocity: function(){
    var element = $$('.average_velocity')[0];
    if(element){
      return Number(element.textContent);
    }
    return 0;
  }
});

/* Iteration */
Strac.Iteration = Class.create();
Object.extend(Strac.Iteration, {
  drawWorkspaceVelocityMarkers: function(){
    Strac.Iteration.removeVelocityMarkers();
    new Strac.Iteration(
      $$(".section .story_list:first")[0]
    ).drawEstimatedVelocityMarkers(Strac.ProjectStats.averageVelocity());    
  },
  
  removeVelocityMarkers: function(){
    $$('.story_list .velocity_marker').invoke("remove");
  }
});
Strac.Iteration.prototype = {
  initialize: function(story_list_element) {
    this.story_list_element = story_list_element;
  },

  drawCurrentIterationEstimationLine: function(story){
    story.element().insert({
      before: '<div class="velocity_marker">' +
        '<div class="right">Next Iteration</div><div class="left">Expected this iteration</div>' +
      '</div>'
    });
  },
  
  drawFutureIterationEstimationLine: function(story){
    story.element().insert({
      before: '<div class="future velocity_marker">' +
        '<div class="left">Future Iteration</div><br class="clearfix"/></div>'
    });    
  },

  drawEstimatedVelocityMarkers: function(velocity){
    var points = 0;
    var drawn_current = false;
    this.stories().each(function(story){
      points += story.points();
      if(points > velocity && !drawn_current){
        this.drawCurrentIterationEstimationLine(story);
        points = story.points();
        drawn_current = true;
      } else if(drawn_current && points > velocity) {
        this.drawFutureIterationEstimationLine(story);
        points = story.points();
      }
    }.bind(this));
  },
  
  stories: function(){
    return this.story_list_element.select(".story_card").map(function(el){
      return new Strac.Story(el);
      Object.extend(el, Strac.Story);
    });
  }
};

/* Story */
Strac.Story = Class.create();
Strac.Story.prototype = {
  initialize: function(story_element) {
    this.story_element = story_element;
  },
  
  element: function(){
    return this.story_element;
  },
  
  points: function(){
    var el = this.story_element.getElementsBySelector(".points")[0];
    var points = 0;
    if(el){
      points = Number(el.textContent);
      points = points ? points : 0
    }
    return points;
  } 
};

/* Window Load Events */
document.observe('dom:loaded', function(){
  Strac.setupCloseButtonForElement($('notice'));
  Strac.setupCloseButtonForElement($('error'));
  Strac.Iteration.drawWorkspaceVelocityMarkers();
});

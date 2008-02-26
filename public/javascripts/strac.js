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
    element.observe("mouseover", function(){
      close.down("span").setStyle({visibility: 'visible'});
    });  
    element.observe("mouseout", function(){
      close.down("span").setStyle({visibility: 'hidden'});
    });  
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
  drawCurrentIterationVelocityMarker: function(){
    Strac.Iteration.removeCurrentIterationVelocityMarker();
    new Strac.Iteration($$(".section .story_list:first")[0]).drawEstimatedCompletionLine(Strac.ProjectStats.averageVelocity());    
  },
  
  removeCurrentIterationVelocityMarker: function(){
    $$('.story_list .velocity_marker').each(function(el){
      el.remove();
    });
  }
});
Strac.Iteration.prototype = {
  initialize: function(story_list_element) {
    this.story_list_element = story_list_element;
  },
  // Number($$('.average_velocity')[0].textContent)
  drawEstimatedCompletionLine: function(velocity){
    var points = 0;
    var stories = this.stories();
    var story;
    for(var i=0, story=stories[i] ; i<stories.size() ; i++, story=stories[i]){
      points += story.points();
      if(points > velocity){
        story.element().insert({
          before: '<div class="velocity_marker">' +
            '<div class="right">Backlog</div><div class="left">Expected this iteration</div>' +
          '</div>'
        });
        break;
      }
    }
  },
  
  stories: function(){
    return this.story_list_element.select(".story_card").map(function(el){
      return new Strac.Story(el);
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
Event.observe(window, 'load', function(){
  Strac.setupCloseButtonForElement($('notice'));
  Strac.setupCloseButtonForElement($('error'));
});

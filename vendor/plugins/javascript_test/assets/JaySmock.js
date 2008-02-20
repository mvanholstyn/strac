function newClass(proto) {
  var f = function() {
    if (this['initialize'])
      this.initialize.apply(this, arguments);
  }
  for(var p in proto) {
    f.prototype[p] = proto[p];
  }
  return f;
}

function arrayContains(array, what) {
  for(var i = 0; i < array.length; i++) {
    if (array[i] == what) {
      return true;
    }
  }
  return false;
}

var setAddAllProperties = function(set, what) {
  var add;
  for(var property in what) {
    if (!arrayContains(set, property)) {
      set.push(property);
    }
  }
}

function deeplyEquals(leftArg, rightArg, options) {
  var path = [];
  options = options || {};
  var messages = options['messages'];
  var rootName = options['rootName'] || "objects";
  
  var strPath = function() {
    var str = rootName;
    for (var i=0; i < path.length; i++) {
      if (isNaN(Number(path[i]))) {
        str += "." + path[i];
      } else {
        str += "[" + path[i] + "]";
      }
    }
    return str;
  }
  
  var objectName = function(obj) {
    if (typeof(obj) == 'object') {
      if (obj == window) {
        return 'window'
      } else if (obj == document) {
        return 'document'
      } else if (obj['mockName']) {
        return 'mock ' + obj.mockName
      }
    }
  };
  
  var _eq = function(left, right) {
    var leftName = objectName(left);
    var rightName = objectName(right);
    
    if (left == right) {
      return true;
      
    } else if (typeof(left) != 'object' || typeof(right) != 'object' || leftName || rightName) {
      if (messages) {
        messages.push(strPath() + ": expected (" + (leftName || left) + ") got (" + (rightName || right) + ")");
      }
      return false;
      
    } else if (typeof(left) == 'object'){
      var retVal = true;
      var props = [];
      setAddAllProperties(props, left);
      setAddAllProperties(props, right);
      
      for(var i = 0; i < props.length; i++) {
        var property = props[i]
        var l = left[property];
        var r = right[property];

        if (messages) {
          path.push(property)
          if(!_eq(l,r))
            retVal = false;
          path.pop();
          
        } else if(!_eq(l,r)){
          retVal = false;
          break;            
        }
      }
      return retVal;
    }
  }
  
  return _eq(leftArg, rightArg);
}

function arrDup(arr1) {
  var arr2 = [];
  for (var i=0; i < arr1.length; i++) {
    arr2[i] = arr1[i];
  };
  return arr2;
}

var JaySmock = {
  extend:function(test) {
    test.mockControl = new JaySmock.Control(test);
    
    this.setUpMockExpect(test, [Object.prototype, Function.prototype, window, document]);

    // Fix for Safari 2
    if (window.Event) {
      this.setUpMockExpect(test, [window.Event]);
    }
    
    test.createMock = function(name) {
      return this.mockControl.createMock(name);
    };
    
    test.verify = function() {
      this.mockControl.verify();
    }
    
    test.assertDeeplyEquals = function(expected, actual, message) {
      if (message) {
        message = message + ": "
      } else {
        message = "";
      }
      var messages = [];
      if (!deeplyEquals(expected, actual, {messages: messages})) {
        message += "Expected " + expected + " but was " + actual + 
          ". Differences:\n" + messages.join("\n");
        
        this.fail(message)
      }
    }
    test.assertDeeplyEqual = test.assertDeeplyEquals;
    
    for(var prop in test) {
      if (/^test/.test(prop)) {        
        test.mockControl.makeVerifyingTest(test, prop);
      }
    }
  },

  setUpMockExpect: function(test, mockExpectables) {
      for(var argumentIndex = 0; argumentIndex < mockExpectables.length; argumentIndex++) {
        var mockExpectable = mockExpectables[argumentIndex];
        mockExpectable.setMockName = function(mockName) {
          if (!this['__mock']) {
            this.__mock = test.createMock(mockName);
          } else {
            this.__mock.mockName = mockName;
          }
        }
        
        mockExpectable.mockOut = function(functionName) {
          if (!this["__mock"]) {
            this.__mock = test.createMock(test.mockControl.mockNameFor(test, this));
          }
          
          var mock = this.__mock;
          test.mockControl.saveMockedMethod(this, functionName, this[functionName])
          
          this[functionName] = function() {
            return mock[functionName].apply(mock, arguments);
          };
          
          mock[functionName] = test.mockControl.makeMockMethod(mock, functionName);
        };
        
        mockExpectable.mockExpect = function() {
          this.mockOut(arguments[0]);
          return this.__mock.expects.apply(this.__mock, arguments)
        }
        mockExpectable.mockExpects = mockExpectable.mockExpect;

        mockExpectable.stubs = function(name, val) {
          test.mockControl.saveMockedMethod(this, name, this[name]);
          this[name] = typeof(val) == 'function' ? val : function() { return val; };
          return this;
        }
      }
    }
};

JaySmock.Control = newClass({
  initialize:function(test) {
    this.test = test;
    this.expectations = [];
    this.mockNames = [];
    this.savedMethods = [];
  },
  
  mockNameFor:function(test, object) {
    for(var property in test) {
      if (test[property] === object) {
        return property;
      };
    }
    
    for(var property in window) {
      if (window[property] === object) {
        return property
      };
    }
    
    if (typeof(object['id']) == 'string') {
      return object.id
    }
    
    if (typeof(object['name']) == 'string') {
      return object.name
    }
    return "mockObject";
  },
  
  saveMockedMethod:function(source, name, func) {
    var found = false;
    for( var i = 0; i < this.savedMethods.length; i++) {
      found = found || (this.savedMethods[i].name == name)
    }
    if (!found) {
      this.savedMethods.push({
        source: source,
        name: name,
        func: func
      });
    }
  },
  
  createMock:function(mockName) {
    return new JaySmock.Mock(this, mockName);
  },
  
  expect: function(src, method, args) {
    this.expectations.push({
      src: src, 
      method: method,
      args: args,
      stub: this.__makeExpectation(src, method, args)
    });
  },
  
  __makeExpectation:function(expectedSrc, expectedMethod, expectedArgs, strict) {
    var test = this.test;
    return function() {
      var messages = [];
      
      var result = true;
      var actualArgs = arrDup(arguments);
      
      if (strict) {
        result = deeplyEquals(expectedArgs, actualArgs, {messages: messages, rootName: 'arguments'});
      } else {
        for(var argIndex = 0; argIndex < expectedArgs.length; argIndex++) {
          if (!deeplyEquals(expectedArgs[argIndex], actualArgs[argIndex], {messages: messages, rootName: 'arguments[' + argIndex + ']'})) {
            result = false;
          }
        }
      }
      
      if(!result) {
        test.fail("Call to " + expectedSrc.mockName + "." + expectedMethod + " had wrong arguments:\n" + 
          messages.join("\n"));
      }
    }
  },
  
  withArgs: function(){
    var expectation = this.expectations[this.expectations.length - 1];
    var args = arrDup(arguments);
    expectation.args = args;
    expectation.stub = this.__makeExpectation(expectation.src, expectation.method, args, true)
    return this;
  },
  
  call: function(src, method, args) {
    if (this.expectations.length == 0) {
      var message = "Unexpected call to " + src.mockName + "." + method + '(' + args.join(", ") + ").";
      this.test.fail(message);
      throw '';
    } else {
      var expectation = this.expectations.shift();
      if (src != expectation.src || method != expectation.method) {
        this.test.fail("Expected call to " + expectation.src.mockName + "." + expectation.method + 
          " did not match actual call " + src.mockName + '.' + method + ".");
      }
      return expectation.stub.apply(this.test || this, args);
    }
  },
  
  verify: function() {
    if (this.expectations.length != 0) {
      var message = "The following expected calls did not happen:";
      for (var i=0; i < this.expectations.length; i++) {
        var e = this.expectations[i];
        message += "\n" + e.src.mockName + "." + e.method + "(" + e.args.join(", ") + ")";
      };
      this.expectations = [];
      this.test.fail(message);
    }
  },
  
  then: function(stub) {
    var oldExpect = this.expectations[this.expectations.length - 1].stub;
    this.expectations[this.expectations.length-1].stub = function() {
      oldExpect.apply(this, arguments);
      return stub.apply(this, arguments);
    };
    return this
  },
  
  returns: function(val) {
    this.then(function() {
      return val;
    });
  },
  
  raises: function(exception) {
    this.then(function() {
      throw exception;
    });
  },
  
  makeVerifyingTest:function(test, testName) {
    var self = this;
    var oldTest = test[testName];
    test[testName] = function() {
      try {
        oldTest.call(this);
        test.verify();
      } finally {
        for (var i=0; i < test.mockControl.savedMethods.length; i++) {
          var saved = test.mockControl.savedMethods[i];
          saved.source.__mock = null;
          saved.source[saved.name] = saved.func;
        };
      }
    }
  },
  
  makeMockMethod:function(target, method) {
    return function() {
      // Should we call methods in the context of this or the context of target?
      // Going with target means mock[method]() will meet the expectation
      return target.control.call(target, method, arrDup(arguments));
    }
  }
});

JaySmock.Mock = newClass({
  initialize:function(control, mockName) {
    this.control = control;
    this.mockName = mockName || 'mock';
  },
  
  expects:function() {
    var args = arrDup(arguments);
    var method = args.shift();
    this[method] = this.control.makeMockMethod(this, method);
    this.control.expect(this, method, args)
    return this.control;
  },
  
  mockOut: function(method) {
    this[method] = this.control.makeMockMethod(this, method);
  }
});

JaySmock.Mock.excludedMethods = ['mockExpect', 'mockExpects', 'setMockName'];
for(var i = 0; i < JaySmock.Mock.excludedMethods.length; i++) {
  JaySmock.Mock.prototype[JaySmock.Mock.excludedMethods[i]] = undefined;
}
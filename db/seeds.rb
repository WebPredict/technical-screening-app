# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name:  "Example User",
             email: "example@example.org",
             password:              "foobar",
             password_confirmation: "foobar",
              activated: true,
              activated_at: Time.zone.now)

50.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

Difficulty.create!(level: "Easy")
Difficulty.create!(level: "Medium")
Difficulty.create!(level: "Hard")

Category.create!(name: "Algorithms")
test = Test.create!(name: "Basic Algorithms Test", description: "This is the basic Algorithms test.", user_id: 1)
test.save


Category.create!(name: "Angular")
question1 = Question.create!(content: "What is AngularJS?", answer: "<p>AngularJS is an open-source JavaScript framework, maintained by Google, that assists with running single-page applications. Its goal is to augment browser-based applications with model???view???controller capability in an effort to make both development and testing easier    </p>", user_id: 1, difficulty_id: 2, category_id: 2)
question2 = Question.create!(content: "Can AngularJS use the jQuery library?", answer: "<p>Angular is able to use jQuery if it exists in the application upon bootstrapping. If jQuery is not present in the script path, Angular reverts to its own implementation of the subset of jQuery known as JQLite.   </p>", user_id: 1, difficulty_id: 2, category_id: 2)
question3 = Question.create!(content: "AngularJS performance is dependent upon what factors?", answer: "<p>Startup performance is dependent on the browser and browser version, network connection, available hardware, and cache state. </p><p>The runtime performance depends on the number and complexity of bindings on the page.  In addition, if an application needs to retrieve data from the backend, the speed of this retrieval will also affect the runtime performance. However, applications can still run efficiently even with thousands of bindings.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question4 = Question.create!(content: "What are directives in AngularJS?", answer: "<p>Directives are markers on a DOM element (such as an attribute, element name, comment or CSS class) that tell AngularJS's HTML compiler to attach a specified behavior to that DOM element, or it may even transform the DOM element and its children.  The directive introduces new syntax.  Directives typically begin with <em>ng</em>.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question5 = Question.create!(content: "What does it mean to \"compile\" an HTML template for AngularJS?", answer: "<p>Compilation means attaching event listeners to the HTML to make it interactive. The reason that the term \"compile\" is used is that the recursive process of attaching directives mirrors the process of compiling source code in compiled programming languages. </p>", user_id: 1, difficulty_id: 2, category_id: 2)
question6 = Question.create!(content: "Explain the compilation process?", answer: "<p>The two phases of the compilation process:</p><ol><li><strong>Compile</strong>: collect all of the directives by traversing the DOM.  A linking function is created from this process.</li><li><strong>Link</strong>: the directives are then combined with a scope to produce a live view. Changes in the scope model are reflected in the view; user interactions with the view are reflected in the scope model.  </li></ol>", user_id: 1, difficulty_id: 2, category_id: 2)
question7 = Question.create!(content: "What are the key features of AngularJS?", answer: "<p>Scope, M-V-C, Services, Data Binding, Directives, Filters, Built-in Validation, and Testability.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question8 = Question.create!(content: "What is meant by scope in AngularJS?", answer: "<p>Scope is an object that refers to the application model. It is the glue between application controller and the view. Both the controllers and directives have reference to the scope, but not with each other. It is an execution context for expressions and arranged in hierarchical structure. Scopes can watch expressions and propagate events.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question9 = Question.create!(content: "Explain the concept of scope hierarchy? How many scopes can an application have?", answer: "<p>Each Angular application has exactly one root scope, but may have several child scopes. The application can have multiple scopes, because child controllers and some directives create new child scopes. When new scopes are created, they are added as children of their parent scope. This creates a hierarchical structure similar to the DOM where they're attached.</p><p>When Angular evaluates a bound variable, such as {{firstName}}, it first looks at the scope associated with the given element for the firstName property. If no such property is found, it searches the parent scope and so on until the root scope is reached. In JavaScript this behavior is known as prototypical inheritance, and child scopes prototypically inherit from their parents. The reverse is not true. For example, the parent cannot see its children's bound properties.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question10 = Question.create!(content: "What is MVC (Model-View-Controller)?", answer: "<p>Model???view???controller (MVC) is a software architectural pattern used to develop user interfaces. The idea is to divide a software application into three interconnected parts.  The purpose of this is to separate the way the user views and interacts with the software from the internal representation of data.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question11 = Question.create!(content: "Briefly explain MVC Architecture?", answer: "<ul><li>M stands for Model.  The Model is your data which may come from an internal data structure, an external JSON doc, or a database.</li><li>V stands for View.  Views are how the data (models) are displayed.  This is commonly accomplished through a template.</li><li>C stands for controllers. Controllers connect the data to the views.  Controllers are written in JavaScript.</li></ul>", user_id: 1, difficulty_id: 2, category_id: 2)
question12 = Question.create!(content: "Explain the concept of bidirectional data binding.", answer: "<p>Data-binding in Angular apps is the automatic synchronization of data between the model and view components. The data is compiled in the browser and the compilation step produces a live view. Code does not need to be written to constantly sync the view with the model and the model with the view as in other templating systems.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question13 = Question.create!(content: "Explain the concept of filters.", answer: "<p>A filter formats the value of an expression for display to the user. They can be used in view templates, controllers, or services.  In addition, developers can define their own filters.</p><p>Filters allow data to be organized automatically.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question14 = Question.create!(content: "How large is the angular.js file that needs to be included in a project?", answer: "<p>When compressed and minified, the file will be less than 36kb.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question15 = Question.create!(content: "Which browsers will AngularJS work with?", answer: "<p>Safari, Chrome, Firefox, Opera 15, IE9, Android, Chrome Mobile, iOS Safari.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question16 = Question.create!(content: "What is a library?", answer: "<p>It is a collection of functions useful when writing web applications.  The programmer&#39;s code calls the function from the library when it needs it. </p>", user_id: 1, difficulty_id: 2, category_id: 2)
question17 = Question.create!(content: "What are frameworks?", answer: "<p>Frameworks are a particular implementation of a web application; the programmer&#39;s code then fills in the details.  In this case, the framework is in charge and calls the programmer&#39;s code when it requires it.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question18 = Question.create!(content: "What are forms in AngularJS?", answer: "<p>Controls are a way for users to input data. Forms are collections of input controls.  They provide validation services to notify the user of invalid input.  This allows for immediate feedback to the user to allow them to correct a mistake.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question19 = Question.create!(content: "What is meant by Markup?", answer: "<p>Markup is the double curly brace notation <strong>{{}}</strong> to bind expressions to elements.  For example:</p><pre><code>  &lt;button ng-click=&quot;changeFoo()&quot;&gt;{{buttonText}}&lt;/button&gt;</code></pre>", user_id: 1, difficulty_id: 2, category_id: 2)
question20 = Question.create!(content: "What are singletons?", answer: "<p>In object-oriented programming, specifically, singletons are classes that are instantiated once.  They have only one instance or object created from the class.  An example of a singleton would be an &quot;Application&quot; class, as only one object can be created of an Application class.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question21 = Question.create!(content: "What are the issues that may be present when using singletons?", answer: "<p>Singletons introduce global state into a program, allowing them to be accessed by anyone at anytime.  They are often used, unnecessarily, by unskilled or thoughtless programers.  This can create programs that are hard to test and that hide their dependencies.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question22 = Question.create!(content: "What are services in AngularJS?", answer: "<p>Services in AngularJS are essentially singletons, passed around, to ensure that the programmer is dealing with the same object each time.  It allows various controllers or directives to affect its values, and it is how the programmer shares date between different chunks of code in the application. The following is an example of a service:</p><pre><code>module.service( &#39;Car&#39;, [ &#39;$rootScope&#39;, function( $rootScope ) {   var service = {     cars: [       { model: &quot;Civic&quot;, manufacturer: &quot;Honda&quot; },       { model: &quot;Focus&quot;, manufacturer: &quot;Ford&quot; }     ],     addCar: function ( car ) {       service.cars.push( car );       $rootScope.$broadcast( &#39;cars.update&#39; );     }   }   return service; }]);</code></pre>", user_id: 1, difficulty_id: 2, category_id: 2)
question23 = Question.create!(content: "What is a controller? Provide an example.", answer: "<p>Controllers in AngularJS are &quot;classes&quot; or &quot;constructor functions&quot; that control the data of an AngularJS application. They are regular JavaScript objects that provide the application behavior that supports the declarative markup in the template.  For example:</p><pre><code>someModule.controller(&#39;MyController&#39;, [&#39;$scope&#39;, &#39;dep1&#39;, &#39;dep2&#39;, function($scope, dep1, dep2) {...$scope.aMethod = function() {  ...}...}]);</code></pre>", user_id: 1, difficulty_id: 2, category_id: 2)
question24 = Question.create!(content: "How should controllers be used?", answer: "<p>Controllers should be used to:</p><ul><li>Set up the initial state of the $scope object.</li><li>Add behavior to the $scope object.</li></ul><p>Controllers should not be used to:</p><ul><li>Manipulate the DOM.  Controllers should contain only business logic not presentation logic.</li><li>Format input.</li><li>Filter output.</li><li>Share code or state across controllers.</li><li>Manage the life-cycle of other components.</li></ul>", user_id: 1, difficulty_id: 2, category_id: 2)
question25 = Question.create!(content: "Explain what business logic is and where it goes in Angular.", answer: "<p>In software engineering, business logic or domain logic does the actual work of the program.  It determines how data is created, displayed, stored, and modified. The controller and services would contain the business logic, typically. </p>", user_id: 1, difficulty_id: 2, category_id: 2)
question26 = Question.create!(content: "What is the $inject property?  Explain its function.", answer: "<p>The <strong>$inject</strong> property is an array of service names to inject. It annotates a function to allow minifiers to rename the function parameters and still inject the proper services.    For example:</p><pre><code>var MyController = function($scope, greeter) {// ...}MyController.$inject = [&#39;$scope&#39;, &#39;greeter&#39;];someModule.controller(&#39;MyController&#39;, MyController);</code></pre>", user_id: 1, difficulty_id: 2, category_id: 2)
question27 = Question.create!(content: "What is a factory method? How are they declared?", answer: "<p>Factory methods define directives, services, and filters and are registered with modules.  It is recommended that they be declared as follows:</p><pre><code>angular.module(&#39;myModule&#39;, []).factory(&#39;serviceId&#39;, [&#39;depService&#39;, function(depService) {  // ...}]).directive(&#39;directiveName&#39;, [&#39;depService&#39;, function(depService) {  // ...}]).filter(&#39;filterName&#39;, [&#39;depService&#39;, function(depService) {  // ...}]);</code></pre>", user_id: 1, difficulty_id: 2, category_id: 2)
question28 = Question.create!(content: "What is Dependency Injection?", answer: "<p>Dependency Injection is a software design pattern where instead of having  objects create a dependency or asking a factory object to make one for them, the needed dependencies are given to components through their constructors, methods, or directly into fields.</p>", user_id: 1, difficulty_id: 2, category_id: 2)
question29 = Question.create!(content: "How is dependency injection used in AngularJS?", answer: "<p>It can be used when defining components or when providing <strong>run</strong> and <strong>config</strong> blocks for a module.  For example:</p><ul><li>Components can be defined by an injectable factory method or constructor function. These components can be injected with &quot;service&quot; and &quot;value&quot; components as dependencies.</li><li>Controllers are defined by a constructor function, which can be injected with any of the &quot;service&quot; and &quot;value&quot; components as dependencies, but they can also be provided with special dependencies.</li><li>The <strong>run</strong> method accepts a function, which can be injected with &quot;service&quot;, &quot;value&quot; and &quot;constant&quot; components as dependencies.</li><li>The <strong>config</strong> method accepts a function, which can be injected with &quot;provider&quot; and &quot;constant&quot; components as dependencies. </li></ul>", user_id: 1, difficulty_id: 2, category_id: 2)
question30 = Question.create!(content: "What are module methods in AngularJS?  Provide an example.", answer: "<p>These are functions that can be specified to run at configuration and runtime for a module by calling the <strong>config</strong> and <strong>run</strong> methods.  They are also injectable with dependencies.  For example:</p><pre><code>angular.module(&#39;myModule&#39;, []).config([&#39;depProvider&#39;, function(depProvider) {  // ...}]).run([&#39;depService&#39;, function(depService) {  // ...}]);</code></pre>", user_id: 1, difficulty_id: 2, category_id: 2)
test = Test.create!(name: "Basic Angular Test", description: "This is the basic Angular test.", user_id: 1)
test.questions << question1
test.questions << question2
test.questions << question3
test.questions << question4
test.questions << question5
test.questions << question6
test.questions << question7
test.questions << question8
test.questions << question9
test.questions << question10
test.questions << question11
test.questions << question12
test.questions << question13
test.questions << question14
test.questions << question15
test.questions << question16
test.questions << question17
test.questions << question18
test.questions << question19
test.questions << question20
test.questions << question21
test.questions << question22
test.questions << question23
test.questions << question24
test.questions << question25
test.questions << question26
test.questions << question27
test.questions << question28
test.questions << question29
test.questions << question30
test.save


Category.create!(name: "Apache")
test = Test.create!(name: "Basic Apache Test", description: "This is the basic Apache test.", user_id: 1)
test.save


Category.create!(name: "Aws")
test = Test.create!(name: "Basic Aws Test", description: "This is the basic Aws test.", user_id: 1)
test.save


Category.create!(name: "Backbone")
test = Test.create!(name: "Basic Backbone Test", description: "This is the basic Backbone test.", user_id: 1)
test.save


Category.create!(name: "Bigarchitecture")
test = Test.create!(name: "Basic Bigarchitecture Test", description: "This is the basic Bigarchitecture test.", user_id: 1)
test.save


Category.create!(name: "Bootstrap")
test = Test.create!(name: "Basic Bootstrap Test", description: "This is the basic Bootstrap test.", user_id: 1)
test.save

#users = User.order(:created_at).take(6)
#50.times do
  #content = Faker::Lorem.sentence(5)
  #users.each { |user| user.microposts.create!(content: content) }
#end


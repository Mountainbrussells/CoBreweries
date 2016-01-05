Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello from the server!");
});

Parse.Cloud.beforeSave("BeerRating", function(request, response) {
  console.log("Before save triggered")
  var user = request.user();
  console.log("got user");
  var username = user.getUsername();
  console.log("Here is the username: " + username);
  request.object.username = username;
  response.success()
})

Parse.Cloud.beforeSave("BreweryRating", function(request, response){
  console.log("beforeSave triggered for BreweryRating")
  response.success()
})

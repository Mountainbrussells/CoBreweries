Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello from the server!");
});

Parse.Cloud.beforeSave("BeerRating", function(request, response) {
  console.log("Before save triggered")
  var userDict = request.object.get("user");
  console.log(userDict);
  var userId = userDict["objectId"];
  console.log(userId);
  var query = new Parse.Query(Parse.User);
  query.equalTo("userId", userId);
  query.find({
    success: function(results) {
      console.log(results);
      var user = results[0];
      var username = user.getUsername();
      console.log("Here is the username: " + username);
      request.object.username = username;
    },
    error: function(){
      console.error();
    }
  });

  response.success()
})

Parse.Cloud.beforeSave("BreweryRating", function(request, response){
  console.log("beforeSave triggered for BreweryRating")
  response.success()
})

/**
 * Module dependencies
 */
var util = require('util');

require('coffee-script');

var express = require('express'),
  passport = require('passport'),
  OAuth2Strategy = require('passport-imgur').Strategy,
  Canvas = require('canvas'),
  routes = require('./routes'),
  http = require('http'),
  https = require('https'),
  path = require('path'),
  fs = require('fs');

var keys = require('./keys.json');
var renderer = require('./assets/js/renderer.coffee');

var dbRegex = /tcp:\/\/(.\S*):(.\S*)/;
var dbAddress = dbRegex.exec(process.env.DB_PORT);
var database = "compromise";
var monkConnect = dbAddress[1]+":"+dbAddress[2]+"/"+database;
console.log(monkConnect);
var db = require('monk')(monkConnect);


var app = module.exports = express();

/**
 * Configuration
 */

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(express.logger('dev'));
app.use(require("connect-assets")());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'assets')));

// development only
if (app.get('env') === 'development') {
  app.use(express.errorHandler());
}

// production only
if (app.get('env') === 'production') {
  // TODO
};

/**
 * imgur OATH
 */

 passport.use('imgur', new OAuth2Strategy({
    authorizationURL: 'https://www.imgur.com/oauth2/authorize',
    tokenURL: 'https://www.imgur.com/oauth2/token',
    clientID: keys.clientID,
    clientSecret: keys.clientSecret,
    callbackURL: 'http://107.170.255.163/auth/imgur/callback'
  },
  function(accessToken, refreshToken, profile, done) {
    console.log(accessToken + " " + refreshToken + " " + profile + " " + done);
  }
));


/**
 * Routes
 */

// serve index and view partials
app.get('/', routes.index);
app.get('/auth/imgur/callback', passport.authenticate('imgur', { successRedirect: '/', failureRedirect: '/' }));

// JSON API
// app.get('/api/name', api.name);

app.post('/generate', function (req, postResponse) {
  console.log(req.body);

  var userTriangle = {
    title: req.body.title,
    top: req.body.top,
    left: req.body.left,
    right: req.body.right
  };

  var hashes = db.get('hashes');

  var existingHash = hashes.findOne(userTriangle);
  existingHash.on('success', function (doc) {
    console.log(util.inspect(doc));
    if (doc){
      var responseObj = {data: {link: doc.link}};
      postResponse.send(responseObj);
    } else {
      generateDoc(userTriangle, postResponse);
    }
  });
  existingHash.on('error', function (message) {
    console.log(message);
  });
});

/**
 * Start Server
 */

http.createServer(app).listen(app.get('port'), function () {
  console.log('Express server listening on port ' + app.get('port'));
});


var generateDoc = function (userTriangle, postResponse) {
  var hashes = db.get('hashes');
  var canvas = new Canvas(500, 463)
  , ctx = canvas.getContext('2d');

  var triangle = {
    title: userTriangle.title,
    topText: userTriangle.top,
    leftText: userTriangle.left,
    rightText: userTriangle.right,
    coords: {
      top: {
        x: 3,
        y: 0
      },
      left: {
        x: 0,
        y: 5.2
      },
      right: {
        x: 6,
        y: 5.2
      },
      center: {
        x: 3,
        y: 3.5
      }
    },
    transforms: {
      scale: 50,
      position: {
        x: 90,
        y: 70
      },
      textOffset: 10,
      fontSize: 18
    }
  }
 
  renderer.render(canvas, ctx, triangle);
  
  canvas.toBuffer(function(err, buf){
    
    // An object of options to indicate where to post to
    var post_options = {
        host: 'api.imgur.com',
        port: '443',
        path: '/3/image',
        method: 'POST',
        headers: {
            'Authorization': 'Client-ID '+ keys.clientID,
            'Content-Length': buf.length
        }
    };

    console.log('making POST request');
    // Set up the request
    var post_req = https.request(post_options, function(res) {
        console.log('got response')
        res.setEncoding('utf8');

        var output = '';
        res.on('data', function (chunk) {
            output += chunk;
        });

        res.on('end', function() {
          var obj = JSON.parse(output);
          console.log('Response: ' + output);
          userTriangle.link = obj.data.link;
          hashes.insert(userTriangle, function (error, doc) {
            if (error) {
              console.log(error);
            }
          });
          postResponse.send(output);
        });
    });

    // post the data
    post_req.write(buf);
    post_req.end();

  });
}

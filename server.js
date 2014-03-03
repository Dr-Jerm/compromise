/**
 * Module dependencies
 */
var util = require('util');

var express = require('express'),
  passport = require('passport'),
  OAuth2Strategy = require('passport-imgur').Strategy,
  Canvas = require('canvas'),
  routes = require('./routes'),
  api = require('./routes/api'),
  http = require('http'),
  https = require('https'),
  path = require('path'),
  fs = require('fs');

require('coffee-script');
var renderer = require('./assets/js/renderer.coffee');

var keys = require('./keys.json');

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

  var canvas = new Canvas(500, 463)
  , ctx = canvas.getContext('2d');

  var triangle = {
    title: req.body.title,
    topText: req.body.top,
    leftText: req.body.left,
    rightText: req.body.right,
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
        res.on('data', function (chunk) {
            console.log('Response: ' + chunk);
            postResponse.send(chunk);
        });
    });

    // post the data
    post_req.write(buf);
    post_req.end();

  });
});

/**
 * Start Server
 */

http.createServer(app).listen(app.get('port'), function () {
  console.log('Express server listening on port ' + app.get('port'));
});

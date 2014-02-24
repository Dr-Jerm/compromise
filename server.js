/**
 * Module dependencies
 */

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

var util = require('util');

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
// app.use(express.bodyParser());
// app.use(express.methodOverride());
app.use(express.static(path.join(__dirname, 'assets')));
// app.use(app.router);

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
    clientID: '***',
    clientSecret: '***',
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
app.get('/partials/:name', routes.partials);

app.get('/auth/imgur/callback', passport.authenticate('imgur', { successRedirect: '/', failureRedirect: '/' }));

// JSON API
// app.get('/api/name', api.name);

app.post('/generate', function (req, res) {
  console.log(req.body);

  var canvas = new Canvas(150, 150)
  , ctx = canvas.getContext('2d');
 
  ctx.fillRect(0,0,150,150);   // Draw a rectangle with default settings
  ctx.save();                  // Save the default state
   
  ctx.fillStyle = '#09F'       // Make changes to the settings
  ctx.fillRect(15,15,120,120); // Draw a rectangle with new settings
   
  ctx.save();                  // Save the current state
  ctx.fillStyle = '#FFF'       // Make changes to the settings
  ctx.globalAlpha = 0.5;    
  ctx.fillRect(30,30,90,90);   // Draw a rectangle with new settings
   
  ctx.restore();               // Restore previous state
  ctx.fillRect(45,45,60,60);   // Draw a rectangle with restored settings
   
  ctx.restore();               // Restore original state
  ctx.fillRect(60,60,30,30);   // Draw a rectangle with restored settings
  
  canvas.toBuffer(function(err, buf){
    
    // An object of options to indicate where to post to
    var post_options = {
        host: 'api.imgur.com',
        port: '443',
        path: '/3/image',
        method: 'POST',
        headers: {
            'Authorization': 'Client-ID '+ '***',
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
        });
    });

    // post the data
    post_req.write(buf);
    post_req.end();

  });

  // var out = fs.createWriteStream(__dirname + '/state.png')
  //   , stream = canvas.createPNGStream();
   
  // stream.on('data', function(chunk){
  //   out.write(chunk);
  // });
});


// redirect all others to the index (HTML5 history)
// app.get('*', routes.index);


/**
 * Start Server
 */

http.createServer(app).listen(app.get('port'), function () {
  console.log('Express server listening on port ' + app.get('port'));
});

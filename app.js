'use strict';

//Modules
var express = require('express');
var app = express();
var server = require('http').createServer(app); 
var logger = require('morgan');
var bodyParser = require('body-parser');
var config = require("./config");   


//Agregamos los header para permitir llamadas externas.
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    res.header("Access-Control-Allow-Headers", "Content-Type");
    res.header("Access-Control-Allow-Methods", "PUT, GET, POST, DELETE, OPTIONS");
    next();
});

//Configure
app.use(logger('dev'));
app.use(bodyParser.json());

//Routes

var executeMainRoute = require('./routes/ExecuteMainRoutes');
var connectionRoute = require('./routes/ConnectionRoutes');

app.use('/api/v1/executemain', executeMainRoute);
app.use('/api/v1/connection', connectionRoute);

//Init Server
server.listen(config.app.PortServer, function () {
  console.log('Start Server port: ' +config.app.PortServer+ '!');
});



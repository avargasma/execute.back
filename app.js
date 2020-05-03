var express = require('express');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
/* var path = require('path');

var fs = require('fs');

const swaggerUi = require('swagger-ui-express');

const swaggerDocument = require('./swagger.json');

var users = require('./routes/UsersRoutes');
var instituciones = require('./routes/InstitucionesRoutes'); */

var app = express();
app.use(bodyParser.json({limit: '10mb', extended: true}))
app.use(bodyParser.urlencoded({limit: '10mb', extended: true}))
app.use(cookieParser())

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Authorization, X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Allow-Request-Method');
    res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE');
    res.header('Allow', 'GET, POST, OPTIONS, PUT, DELETE');
    next();
});

var executeMainRoute = require('./routes/ExecuteMainRoutes');
var connectionRoute = require('./routes/ConnectionRoutes');

app.use('/api/v1/executemain', executeMainRoute);
app.use('/api/v1/connection', connectionRoute);

//app.use('/api/v1', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

module.exports = app;

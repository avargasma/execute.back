var fs = require("fs");
const sql = require('mssql');

exports.execute = (req, res, next) => {
  
    var wServer = req.body.server;
    var wUser = req.body.user;
    var wPass = req.body.password;
    var wDatabase = req.body.database;
    var wScript = req.body.script;

    const config = {
        user: wUser,
        password: wPass,
        server: wServer,
        database: wDatabase,
    } 

    sql.connect(config, function (err) {
    
        if (err) console.log(err);
        const request = new sql.Request()
        request.query(wScript, (err, result) => {                
            return res.status(200).json({
                result:(err)? err : 'Execute ok'
            });                         
        });
    });       
};
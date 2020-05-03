let { configconnection, security } = require('../config.js');
var fs = require("fs");
const sql = require('mssql')

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

    const sql = require('mssql')    

    sql.connect(config, function (err) {
    
        if (err) console.log(err);
        const request = new sql.Request()
        request.query(wScript, (err, result) => {                
            return res.status(200).json({
                result:(err)? err : 'Execute ok'
            });                         
        });
    });
       /*  var resf = [];
        var fall = 0;
        var files = fs.readdirSync('./scripts/');
        for (let indexf = 0; indexf < files.length; indexf++) {
            if (fall) {
                break;
            }
            const element = files[indexf];
            var text = fs.readFileSync('./scripts/'+element, "utf-8");

            var wText = text.split('GO');   
            for (let index = 0; index < wText.length; index++) {
                const value = wText[index];
                const request = new sql.Request()
                request.query(value, (err, result) => {
                    resf.push((err)? err: result);   
                    if (err){
                        fall++;
                        return res.status(200).json({
                            result: err
                        });
                    }  
                    console.log('exec '+ value + 'err: ' + err);        
                    if (indexf == 1) {
                        return res.status(200).json({
                            result: (err)? err: result
                        });
                    }    
                });
            }
                                 
        } */
};
let { configconnection, security } = require('../config.js');
const sql = require('mssql')


exports.startConnect = (req, res, next) => {
  
    var wServer = req.body.server;
    var wUser = req.body.user;
    var wPass = req.body.password;

    const config = {
        user: wUser,
        password: wPass,
        server: wServer,
        database: 'master',
    }

    new sql.ConnectionPool(config).connect().then(pool => {
        return pool.query`SELECT DB.database_id, DB.name FROM [master].[sys].[databases] DB 
                        WHERE name NOT IN ('master', 'model', 'tempdb', 'msdb', 'Resource')`
    }).then(result => {
        return res.status(200).json({
            result: result['recordset']
        }); 
    }).catch(err => {
        return res.status(500).json({
            message: err
        }); 
    });      

};
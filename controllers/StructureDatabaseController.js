const sql = require('mssql');

exports.tablespost = (req, res, next) => {
  
    var wServer = req.body.server;
    var wUser = req.body.user;
    var wPass = req.body.password;
    var wDatabase = req.body.database;
    var wScript = `USE `+ wDatabase +`; SELECT TABLE_SCHEMA, TABLE_NAME, 
                    CONCAT(TABLE_SCHEMA,'.', TABLE_NAME) AS NameFormat
                    FROM INFORMATION_SCHEMA.TABLES 
                    WHERE TABLE_TYPE = 'BASE TABLE' 
                    AND TABLE_CATALOG='`+ wDatabase +`'
                    ORDER BY NameFormat`;

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
                result:(err)? err : result['recordset']
            });                         
        });
    });       
};

exports.storeprocedurespost = async (req, res, next) => {
  
    var wServer = req.body.server;
    var wUser = req.body.user;
    var wPass = req.body.password;
    var wDatabase = req.body.database;
    var wScript = `USE `+ wDatabase +`; SELECT ROUTINE_SCHEMA, ROUTINE_NAME,
                    Convert(nvarchar(150),ROUTINE_SCHEMA)+'.'+Convert(nvarchar(150),ROUTINE_NAME) AS NameFormat
                    FROM [`+ wDatabase +`].INFORMATION_SCHEMA.ROUTINES
                    WHERE ROUTINE_TYPE = 'PROCEDURE'
                    ORDER BY NameFormat`;



    const config = {
        user: wUser,
        password: wPass,
        server: wServer,
        database: wDatabase,
    } 
    const pool = new sql.ConnectionPool(config);
    pool.on('error', err => {
        return res.status(200).json({
            result: err
        }); 
    });
  
    try {
      await pool.connect();
      let result = await pool.request().query(wScript);
      return res.status(200).json({
            result: result['recordset']
        });  
    } catch (err) { 
        return res.status(200).json({
            result: err
        }); 
    } finally {
      pool.close(); //closing connection after request is finished.
    }

    /* sql.connect(config, function (err) {
    
        if (err) console.log(err);
        const request = new sql.Request()
        request.query(wScript, (err, result) => {                
            return res.status(200).json({
                result:(err)? err : result['recordset']
            });                         
        });
    });     */   
};

exports.storeproceduretextpost = async (req, res, next)=> {

    var wServer = req.body.server;
    var wUser = req.body.user;
    var wPass = req.body.password;
    var wDatabase = req.body.database;
    var wStoreProcName = req.body.objectname;
    var wScript = `USE `+ wDatabase +`; DECLARE @Lines TABLE (Line NVARCHAR(MAX)) ;
    DECLARE @FullText NVARCHAR(MAX) = '' ;
    
    INSERT @Lines EXEC sp_helptext '`+ wStoreProcName +`' ;
    SELECT @FullText = @FullText + Line FROM @Lines ; 
    
    SELECT @FullText AS TextStoreProcedure;`;

    const config = {
        user: wUser,
        password: wPass,
        server: wServer,
        database: wDatabase,
    } 
    
    const pool = new sql.ConnectionPool(config);
    pool.on('error', err => {
        return res.status(200).json({
            result: err
        }); 
    });
  
    try {
      await pool.connect();
      let result = await pool.request().query(wScript);
      return res.status(200).json({
            result: result['recordset']
        });  
    } catch (err) { 
        return res.status(200).json({
            result: err
        }); 
    } finally {
      pool.close(); //closing connection after request is finished.
    }

  };

/* exports.storeproceduretextpost = (req, res, next) => {
  
    var wServer = req.body.server;
    var wUser = req.body.user;
    var wPass = req.body.password;
    var wDatabase = req.body.database;
    var wStoreProcName = req.body.objectname;
    var wScript = `USE `+ wDatabase +`; DECLARE @Lines TABLE (Line NVARCHAR(MAX)) ;
    DECLARE @FullText NVARCHAR(MAX) = '' ;
    
    INSERT @Lines EXEC sp_helptext '`+ wStoreProcName +`' ;
    SELECT @FullText = @FullText + Line FROM @Lines ; 
    
    SELECT @FullText AS TextStoreProcedure;`;

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
                result:(err)? err : result['recordset']
            });                         
        });
    });       
}; */

exports.viewspost = (req, res, next) => {
  
    var wServer = req.body.server;
    var wUser = req.body.user;
    var wPass = req.body.password;
    var wDatabase = req.body.database;
    var wScript = `USE `+ wDatabase +`; SELECT OBJECT_SCHEMA_NAME(v.object_id) schema_name,	v.name, 
                    CONCAT(OBJECT_SCHEMA_NAME(v.object_id),'.',	v.name) AS NameFormat
                    FROM sys.views as v;`;

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
                result:(err)? err : result['recordset']
            });                         
        });
    });       
};
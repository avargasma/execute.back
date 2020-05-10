var express = require('express');
var router = express.Router();

const structureDatabaseController = require('../controllers/StructureDatabaseController');

router.post("/tables", structureDatabaseController.tablespost);
router.post("/storeprocedures", structureDatabaseController.storeprocedurespost);
router.post("/views", structureDatabaseController.viewspost);
router.post("/storeproceduretext", structureDatabaseController.storeproceduretextpost);


module.exports = router;
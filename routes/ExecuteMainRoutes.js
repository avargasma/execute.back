var express = require('express');
var router = express.Router();

const executeMainController = require('../controllers/ExecuteMainController');

router.post("/", executeMainController.execute);


module.exports = router;
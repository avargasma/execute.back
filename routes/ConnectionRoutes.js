var express = require('express');
var router = express.Router();

const connectionController = require('../controllers/ConnectionController');

router.post("/", connectionController.startConnect);


module.exports = router;
// This is a test harness for your module
// You should do something interesting in this harness
// to test out the module and to provide instructions
// to users on how to use it by example.


// open a single window
// ****************************************************************************************************************
// ****************************************************************************************************************
// test value can be 'raw' | 'socket.io' | 'nowjs'

var test = 'raw', 

// ****************************************************************************************************************
// ****************************************************************************************************************
// REMEMBER to change this with your data

uri = 'ws://104.156.251.75:8080/'; 

// ****************************************************************************************************************
// ****************************************************************************************************************
// example using a plain websockets

if ('raw' === test) {
	// TODO: write your module tests here
	var WS = require('com.ashish.socketmodule').createWS();
	Ti.API.info("module is => " + WS);

	WS.addEventListener('open', function () {
		Ti.API.debug('websocket opened');
	});

	WS.addEventListener('close', function (ev) {
		Ti.API.info(ev);
	});

	WS.addEventListener('error', function (ev) {
		Ti.API.error(ev);
	});

	WS.addEventListener('message', function (ev) {
		Ti.API.log(ev);
	});
	
	WS.open(uri,['echo-protocol']);
}

// ****************************************************************************************************************
// ****************************************************************************************************************
// example using socket.io which uses websocket

else if ('socket.io' === test) {
	var io = require('socket.io'),
	socket = io.connect(uri);
	
	socket.on('connect', function () {
		Ti.API.log('connected!')
	});
}

// ****************************************************************************************************************
// ****************************************************************************************************************
// example using now.js which uses socket.io which uses websockets

else if ('nowjs' === test) {
	var now = require('now').nowInitialize(uri, {
		// socket.io init options
		socketio: {
			transports: ['websocket']
		}
	});

	now.core.on('error', function () {
		Ti.API.error('error!')
	});

	now.core.on('ready', function () {
		Ti.API.log('now is now ready')
	});

	now.core.on('disconnect', function () {
		Ti.API.log('now disconnected');
	});

	// now data bindings
	now.userID = '4815162342';
	now.whatLiesInTheShadowOfTheStatue = function () {
		return 'ille qui nos omnes servabit';
	};
}
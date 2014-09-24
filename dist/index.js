/**
 *  bookshelf.raw.safe
 *
 * @version: 0.0.1
 * @author: Nicholas McCready
 * @date: Wed Sep 24 2014 12:49:58 GMT-0400 (EDT)
 * @license: MIT

    
 _                 _        _          _  __                                __
| |__   ___   ___ | | _____| |__   ___| |/ _| _ __ __ ___      _____  __ _ / _| ___
| '_ \ / _ \ / _ \| |/ / __| '_ \ / _ \ | |_ | '__/ _` \ \ /\ / / __|/ _` | |_ / _ \
| |_) | (_) | (_) |   <\__ \ | | |  __/ |  _|| | | (_| |\ V  V /\__ \ (_| |  _|  __/
|_.__/ \___/ \___/|_|\_\___/_| |_|\___|_|_|(_)_|  \__,_| \_/\_(_)___/\__,_|_|  \___|

 */
var Promise, handleError, makeStringLoggable, myDummyLogger, status, _;

Promise = require('bluebird');

status = require('http-status');

_ = require('lodash');

makeStringLoggable = function(name) {
  if (!name) {
    return;
  }
  name = name + ': ';
  return name;
};


/*
  Function to handle the basic rows convertion to JSON and handle basic error logging.
  In all error cases a Promise should be returned!

  @pram {object} db - database object, bookshelf
  @pram {string} sql - sql string to be sent to the db
  @pram {function} next - express error handler
  @pram {string} - callingFnName (optional) - string of calling function for logging
  @return {object} Promise
 */

handleError = function(callingFnName, e, status, next) {
  logger.error("failed to " + callingFnName + e.message);
  if (typeof next === "function") {
    next({
      status: status,
      message: e.message
    });
  }
  e.isLogged = true;
  return Promise.reject(e);
};

myDummyLogger = _.extend(console, {
  debug: function() {
    return console.info.apply(null, arguments);
  }
});

module.exports = function(logger) {
  if (logger == null) {
    logger = myDummyLogger;
  }
  return {
    safeQuery: function(db, sql, next, callingFnName) {
      if (callingFnName == null) {
        callingFnName = 'bookshelf.raw';
      }
      if (!db) {
        return Promise.reject('db is not defined');
      }
      if (!sql) {
        return Promise.reject('sql is not defined');
      }
      makeStringLoggable(callingFnName);
      return db.knex.raw(sql).then(function(data) {
        logger.log('sql', 'result: data.rows: %j', data.rows, {});
        if (data.rows) {
          return data.rows;
        } else {
          return [];
        }
      })["catch"](function(e) {
        return handleError(callingFnName, e, status.NOT_FOUND, next);
      });
    }
  };
};

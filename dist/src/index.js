var Promise, makeStringLoggable, myDummyLogger, status, _;

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

myDummyLogger = _.extend(console, {
  debug: function() {
    return console.info.apply(null, arguments);
  }
});

module.exports = function(logger) {
  var handleError;
  if (logger == null) {
    logger = myDummyLogger;
  }
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

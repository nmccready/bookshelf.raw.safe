bookshelf.raw.safe
==================

Bookshelf raw extensions to handle things in a safe manner


The idea is to pass error handling up the chain to express, and to always be returning (bluebird)
promises.

```
var safeBookShelf = require('bookshelf.raw.safe')(loggerOfYourChoice);
var safeQuery = safeBookShelf.safeQuery;

# db = bookshelf instance / connection
# next is an error callback function passing an error up (intended for express)

var callingFnName = 'getAll';
var getAll = function(){
  safeQuery(db, sqlString, next, callingFnName);
};
```

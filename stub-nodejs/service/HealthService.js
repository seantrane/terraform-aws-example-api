'use strict';


/**
 * API Healthcheck
 * Check the health of API.
 *
 * returns ApiResponse
 **/
exports.health = function() {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "code" : 200,
  "message" : "Testing",
  "timestamp" : 946684800,
  "type" : "String"
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


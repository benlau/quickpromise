var fs = require('fs');
var promisesAplusTests = require("promises-aplus-tests");

var fileData = fs.readFileSync('../../QuickPromise/q.js',                               
                               'utf8');

var res = fileData.replace(/.pragma library/i,"")
                  .replace(/.import.*/i,"")
                  .replace(/QP.QPTimer./g,"");

eval(res);

var adapter = {
    deferred: function() {
        var p = promise();
        return {
            promise: p,
            resolve: function(x) {p.resolve(x)},
            reject: function(x) {p.reject(x)}            
        }        
    }
}

promisesAplusTests(adapter, function (err) {
    // All done; output is in the console. Or check `err` for number of failures.
});
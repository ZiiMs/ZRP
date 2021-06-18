const mongodb = require('mongodb');

const uri = GetConvar('mongo_uri', '')
const dbName = GetConvar('mongo_db', '')

let db;

const RetrieveComponents = () => {
  Logger = exports['zrp-core']['FetchComponent']('Logger')
}

on('Core:Shared:Ready', () => {
  exports['zrp-core']['RequestDependencies']('Base', [
    'Logger',
  ], (e) => {
    if (e > 0) {
      console.log('Errors', e[1]);
      return;
    }
    RetrieveComponents();
    
  })
})

const Connect = () => {
  if (url != '' && dbName != '') {
    mongodb.MongoClient.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true }, function(error, client) {
      if(error) return Logger.Error('', 'MongoDB', `Failed to connect: ${error.message}`)
      db = client.db(dbName);

      Logger.Trace('', 'MongoDB', `Connected to database ${dbName}`, "test");
      emit('onDatabaseConnect', dbName);
    });
  } else {
    if (uri == '') Logger.Error('', 'MongoDB', `Convar "mongo_uri" not set`);
    if (dbName == '') Logger.Error('', 'MongoDB', `Convar "mongo_db" not set`);
  }
}

function checkDatabaseReady() {
  if (!db) {
      Logger.Error('', 'MongoDB', `Database is not connected.`);
      return false;
  }
  return true;
}

function checkParams(params) {
  return params !== null && typeof params === 'object';
}

function getParamsCollection(params) {
  if (!params.collection) return;
  return db.collection(params.collection)
}

const Database = {
  /**
 * MongoDB insert method
 * @param {Object} params - Params object
 * @param {Array}  params.documents - An array of documents to insert.
 * @param {Object} params.options - Options passed to insert.
 */
  insert: function(params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.insert: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

    let documents = params.documents;
    if (!documents || !Array.isArray(documents))
        return console.log(`[MongoDB][ERROR] exports.insert: Invalid 'params.documents' value. Expected object or array of objects.`);

    const options = utils.safeObjectArgument(params.options);

    collection.insertMany(documents, options, (err, result) => {
        if (err) {
            console.log(`[MongoDB][ERROR] exports.insert: Error "${err.message}".`);
            utils.safeCallback(callback, false, err.message);
            return;
        }
        let arrayOfIds = [];
        // Convert object to an array
        for (let key in result.insertedIds) {
            if (result.insertedIds.hasOwnProperty(key)) {
                arrayOfIds[parseInt(key)] = result.insertedIds[key].toString();
            }
        }
        utils.safeCallback(callback, true, result.insertedCount, arrayOfIds);
    });
    process._tickCallback();
  },

  /**
  * MongoDB find method
  * @param {Object} params - Params object
  * @param {Object} params.query - Query object.
  * @param {Object} params.options - Options passed to insert.
  * @param {number} params.limit - Limit documents count.
  */
  find: function(params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.find: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

    const query = utils.safeObjectArgument(params.query);
    const options = utils.safeObjectArgument(params.options);

    let cursor = collection.find(query, options);
    if (params.limit) cursor = cursor.limit(params.limit);
    cursor.toArray((err, documents) => {
        if (err) {
            console.log(`[MongoDB][ERROR] exports.find: Error "${err.message}".`);
            utils.safeCallback(callback, false, err.message);
            return;
        };
        utils.safeCallback(callback, true, utils.exportDocuments(documents));
    });
    process._tickCallback();
  },

  /**
  * MongoDB update method
  * @param {Object} params - Params object
  * @param {Object} params.query - Filter query object.
  * @param {Object} params.update - Update query object.
  * @param {Object} params.options - Options passed to insert.
  */
  update: function(params, callback, isUpdateOne) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.update: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

    query = utils.safeObjectArgument(params.query);
    update = utils.safeObjectArgument(params.update);
    options = utils.safeObjectArgument(params.options);

    const cb = (err, res) => {
        if (err) {
            console.log(`[MongoDB][ERROR] exports.update: Error "${err.message}".`);
            utils.safeCallback(callback, false, err.message);
            return;
        }
        utils.safeCallback(callback, true, res.result.nModified);
    };
    isUpdateOne ? collection.updateOne(query, update, options, cb) : collection.updateMany(query, update, options, cb);
    process._tickCallback();
  },

  /**
  * MongoDB count method
  * @param {Object} params - Params object
  * @param {Object} params.query - Query object.
  * @param {Object} params.options - Options passed to insert.
  */
  count: function(params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.count: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

    const query = utils.safeObjectArgument(params.query);
    const options = utils.safeObjectArgument(params.options);

    collection.countDocuments(query, options, (err, count) => {
        if (err) {
            console.log(`[MongoDB][ERROR] exports.count: Error "${err.message}".`);
            utils.safeCallback(callback, false, err.message);
            return;
        }
        utils.safeCallback(callback, true, count);
    });
    process._tickCallback();
  },

  /**
  * MongoDB delete method
  * @param {Object} params - Params object
  * @param {Object} params.query - Query object.
  * @param {Object} params.options - Options passed to insert.
  */
  delete: function(params, callback, isDeleteOne) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.delete: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

    const query = utils.safeObjectArgument(params.query);
    const options = utils.safeObjectArgument(params.options);

    const cb = (err, res) => {
        if (err) {
            console.log(`[MongoDB][ERROR] exports.delete: Error "${err.message}".`);
            utils.safeCallback(callback, false, err.message);
            return;
        }
        utils.safeCallback(callback, true, res.result.n);
    };
    isDeleteOne ? collection.deleteOne(query, options, cb) : collection.deleteMany(query, options, cb);
    process._tickCallback();
  },
  isConnected: () => !!db,
  insertOne: (params, callback) => {
    if (checkParams(params)) {
      params.documents = [params.document];
      params.document = null;
    }
    Database.insert(params, callback);
  },
  findOne: (params, callback) => {
    if (checkParams(params)) params.limit = 1;
    this.find(params, callback);
  },
  updateOne: (params, callback) => {
    this.update(params, callback, true);
  },
  deleteOne: (params, callback) => {
    this.delete(params, callback, true);
  },
  Test: () => { 
    console.log("Test!?!")
  },
}

on('Proxy:Shared:RegisterReady', () => {
  console.log('Index.js Registering!?!?')
  exports['zrp-core']['RegisterComponent']('Database', Database)
})

Connect();

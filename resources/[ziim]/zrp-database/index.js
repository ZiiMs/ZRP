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
    Connect();
  })
})

const Connect = () => {
  if (url != '' && dbName != '') {
    if(!db) {
      mongodb.MongoClient.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true }, function(error, client) {
        if(error) return Logger.Error('', 'MongoDB', `Failed to connect: ${error.message}`)
        db = client.db(dbName);
        
        
        Logger.Trace('', 'MongoDB', `Connected to database ${dbName}`, "test");
        emit('onDatabaseConnect', dbName);
      });
    }
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

function exportDocument(document) {
  if (!document) return;
  if (document._id && typeof document._id !== "string") {
      document._id = document._id.toString();
  }
  return document;
};

function exportDocuments(documents) {
  if (!Array.isArray(documents)) return;
  return documents.map((document => exportDocument(document)));
}

function safeObjectArgument(object) {
  if (!object) return {};
  if (Array.isArray(object)) {
      return object.reduce((acc, value, index) => {
          acc[index] = value;
          return acc;
      }, {});
  }
  if (typeof object !== "object") return {};
  if (object._id) object._id = mongodb.ObjectID(object._id);
  return object;
}

function safeCallback(cb, ...args) {
  if (typeof cb === "function") return setImmediate(() => cb(...args));
  else return false;
}


const Database = {
  /**
 * MongoDB insert method
 * @param {Object} params - Params object
 * @param {Array}  params.documents - An array of documents to insert.
 * @param {Object} params.options - Options passed to insert.
 */
  insert: function(self, params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return Logger.Error(self, 'MongoDB', ` Database.insert: Invalid params object.`);
    let collection = getParamsCollection(params);
    if (!collection) return Logger.Error(self, 'MongoDB', ` Database.insert: Invalid collection "${params.collection}"`);

    let documents = params.documents;
    if (!documents || !Array.isArray(documents))
        return Logger.Error(self, 'MongoDB', ` Database.insert: Invalid 'params.documents' value. Expected object or array of objects.`);

    const options = safeObjectArgument(params.options);

    collection.insertMany(documents, options, (err, result) => {
        if (err) {
            Logger.Error(self, 'MongoDB', ` Database.insert: Error "${err.message}".`);
            safeCallback(callback, false, err.message);
            return;
        }
        let arrayOfIds = [];
        // Convert object to an array
        for (let key in result.insertedIds) {
            if (result.insertedIds.hasOwnProperty(key)) {
                arrayOfIds[parseInt(key)] = result.insertedIds[key].toString();
            }
        }
        safeCallback(callback, true, result.insertedCount, arrayOfIds);
    });
    process._tickCallback();
  },

   /**
   * MongoDB insertOne method
   * @param {Object} params - Params object
   * @param {Array}  params.document - An array of documents to insert.
   * @param {Object} params.options - Options passed to insert.
   */
    insertOne: function(self, params, callback) {
      if (!checkDatabaseReady()) return;
      if (!checkParams(params)) return Logger.Error(self, 'MongoDB', ` Database.insertOne Invalid params object.`);
      let collection = getParamsCollection(params);
      if (!collection) return Logger.Error(self, 'MongoDB', ` Database.insertOne Invalid collection "${params.collection}"`);
  
      let document = params.document;
      print(JSON.stringify(document))
      if (!document)
          return Logger.Error(self, 'MongoDB', ` Database.insertOne Invalid 'params.document' value. Expected object or array of objects.`);
  
      const options = safeObjectArgument(params.options);
  
      collection.insertOne(document, options, (err, result) => {
          if (err) {
              Logger.Error(self, 'MongoDB', ` Database.insertOne: Error "${err.message}".`);
              safeCallback(callback, false, err.message);
              return;
          }
          console.log(JSON.stringify(result))
          safeCallback(callback, true, result.acknowledged, result.insertedId);
      });
      process._tickCallback();
    },

  /**
  * MongoDB index method
  * @param {Object} params - Params object
  * @param {Object} params.query - Query object.
  * @param {Object} params.options - Options passed to insert.
  */
   createIndex: function(self, params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return Logger.Error(self, 'MongoDB', ` Database.createIndex: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return Logger.Error(self, 'MongoDB', ` Database.createIndex: Invalid collection "${params.collection}"`);

    const query = safeObjectArgument(params.query);
    const options = safeObjectArgument(params.options);

    collection.createIndex(query, options, (err, count) => {
        if (err) {
            Logger.Error(self, 'MongoDB', ` Database.count: Error "${err.message}".`);
            safeCallback(callback, false, err.message);
            return;
        }
        safeCallback(callback, true, count);
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
  find: function(self, params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return Logger.Error(self, 'MongoDB', ` Database.find: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return Logger.Error(self, 'MongoDB', ` Database.find: Invalid collection "${params.collection}"`);

    const query = safeObjectArgument(params.query);
    const options = safeObjectArgument(params.options);

    let cursor = collection.find(query, options);
    if (params.limit) cursor = cursor.limit(params.limit);
    cursor.toArray((err, documents) => {
        if (err) {
            Logger.Error(self, 'MongoDB', ` Database.find: Error "${err.message}".`);
            safeCallback(callback, false, err.message);
            return;
        };
        safeCallback(callback, true, exportDocuments(documents));
    });
    process._tickCallback();
  },

  /**
  * MongoDB find method
  * @param {Object} params - Params object
  * @param {Object} params.query - Query object.
  * @param {Object} params.options - Options passed to insert.
  */
  findOne: function(self, params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return Logger.Error(self, 'MongoDB', ` Database.findOne: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return Logger.Error(self, 'MongoDB', ` Database.findOne: Invalid collection "${params.collection}"`);

    const query = safeObjectArgument(params.query);
    const options = safeObjectArgument(params.options);

    collection.findOne(query, options).then((document) => {
      if(document == null) throw("Document not found.")
      safeCallback(callback, true, exportDocument(document));
    }).catch((e) => {
      Logger.Error(self, 'MongoDB', ` Database.findOne: Error "${e}".`);
      safeCallback(callback, false, e);
      return;
    });
    process._tickCallback();
  },

  /**
  * MongoDB find method
  * @param {Object} params - Params object
  * @param {Object} params.query - Filter query object.
  * @param {Object} params.update - Update query object.
  * @param {Object} params.options - Options passed to insert.
  */
  findOneAndUpdate: function(self, params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return Logger.Error(self, 'MongoDB', ` Database.findOneAndUpdate: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return Logger.Error(self, 'MongoDB', ` Database.findOneAndUpdate: Invalid collection "${params.collection}"`);

    query = safeObjectArgument(params.query);
    update = safeObjectArgument(params.update);
    options = safeObjectArgument(params.options);
    options.returnDocument = 'after'
    collection.findOneAndUpdate(query, update, options).then(updatedDocument => {
      if(updatedDocument.lastErrorObject.n != 0) {
        Logger.Trace(self, "MongoDB", `Updated document ${JSON.stringify(updatedDocument)}.`)
      } else {
        // Logger.Trace(self, "MongoDB", `No document matches the provided query: ${updatedDocument}.`)
        throw(`No document matches the provided query`);
      }
      safeCallback(callback, true, updatedDocument);
    }).catch(err => {
      Logger.Error(self, 'MongoDB', ` Database.findOneAndUpdate: Error "${err}".`);
      safeCallback(callback, false, err);
      return;
    })
    // collection.findOneAndUpdate(query, update, options, (err, res) => {
    //   if (err) {
    //     Logger.Error(self, 'MongoDB', ` Database.findOneAndUpdate: Error "${err.message}".`);
    //     safeCallback(callback, false, err.message);
    //     return;
    //   }
    //   console.log(err)
    //   console.log(query)
    //   safeCallback(callback, true, res.value);
    // });
    process._tickCallback();
  },

  /**
  * MongoDB update method
  * @param {Object} params - Params object
  * @param {Object} params.query - Filter query object.
  * @param {Object} params.update - Update query object.
  * @param {Object} params.options - Options passed to insert.
  */
  update: function(self, params, callback, isUpdateOne) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return Logger.Error(self, 'MongoDB', ` Database.update: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return Logger.Error(self, 'MongoDB', ` Database.update: Invalid collection "${params.collection}"`);

    query = safeObjectArgument(params.query);
    update = safeObjectArgument(params.update);
    options = safeObjectArgument(params.options);

    const cb = (err, res) => {
        if (err) {
            Logger.Error(self, 'MongoDB', ` Database.update: Error "${err.message}".`);
            safeCallback(callback, false, err.message);
            return;
        }
        safeCallback(callback, true, res.result.nModified);
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
  count: function(self, params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return Logger.Error(self, 'MongoDB', ` Database.count: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return Logger.Error(self, 'MongoDB', ` Database.count: Invalid collection "${params.collection}"`);

    const query = safeObjectArgument(params.query);
    const options = safeObjectArgument(params.options);

    collection.countDocuments(query, options, (err, count) => {
        if (err) {
            Logger.Error(self, 'MongoDB', ` Database.count: Error "${err.message}".`);
            safeCallback(callback, false, err.message);
            return;
        }
        safeCallback(callback, true, count);
    });
    process._tickCallback();
  },

  /**
  * MongoDB delete method
  * @param {Object} params - Params object
  * @param {Object} params.query - Query object.
  * @param {Object} params.options - Options passed to insert.
  */
  delete: function(self, params, callback, isDeleteOne) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return Logger.Error(self, 'MongoDB', ` Database.delete: Invalid params object.`);

    let collection = getParamsCollection(params);
    if (!collection) return Logger.Error(self, 'MongoDB', ` Database.delete: Invalid collection "${params.collection}"`);

    const query = safeObjectArgument(params.query);
    const options = safeObjectArgument(params.options);

    const cb = (err, res) => {
        if (err) {
            Logger.Error(self, 'MongoDB', ` Database.delete: Error "${err.message}".`);
            safeCallback(callback, false, err.message);
            return;
        }
        safeCallback(callback, true, res.result.n);
    };
    isDeleteOne ? collection.deleteOne(query, options, cb) : collection.deleteMany(query, options, cb);
    process._tickCallback();
  },

  isConnected: (self) => !!db,
  // insertOne: (self, params, callback) => {
  //   if (checkParams(params)) {
  //     params.documents = [params.document];
  //     params.document = null;
  //   }
  //   Database.insert(self, params, callback);
  // },
  // findOne: (self, params, callback) => {
  //   if (checkParams(params)) params.limit = 1;
  //   Database.find(self, params, callback);
  // },
  updateOne: (self, params, callback) => {
    Database.update(self, params, callback, true);
  },
  deleteOne: (self, params, callback) => {
    Database.delete(self, params, callback, true);
  },
}

on('Proxy:Shared:RegisterReady', () => {
  console.log('Index.js Registering!?!?')
  exports['zrp-core']['RegisterComponent']('Database', Database)
})


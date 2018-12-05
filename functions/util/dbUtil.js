const admin = require('firebase-admin')
const db = require('../index').db

const appsRef = db.collection('app')

exports.saveSearchHistory = (uid, query) =>
  db
    .collection('user')
    .doc(uid)
    .collection('searchHistory')
    .add({
      query: query,
      timestamp: admin.firestore.FieldValue.serverTimestamp()
    })

exports.saveApps = apps => {
  const batch = db.batch()
  apps.forEach(app => batch.set(appsRef.doc(app['trackId'].toString()), app))
  return batch.commit()
}

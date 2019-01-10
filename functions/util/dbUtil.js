const admin = require('firebase-admin')
const db = require('../index').db

const querySize = 50

deleteCollection = collection => {
  const ref = db.collection(collection)
  return ref
    .get()
    .then(snapshot =>
      Promise.all(snapshot.docs.map(doc => ref.doc(doc.id).delete()))
    )
}

exports.saveSearch = query =>
  db.collection('search').add({
    query: query,
    date: admin.firestore.FieldValue.serverTimestamp()
  })

exports.saveApps = apps => {
  const batch = db.batch()
  apps.forEach(app => {
    app['searchDate'] = admin.firestore.FieldValue.serverTimestamp()
    batch.set(db.collection('app').doc(app['trackId'].toString()), app, {
      merge: true
    })
  })
  return batch.commit()
}

exports.getRecentSearches = () =>
  new Promise((resolve, reject) =>
    db
      .collection('search')
      .orderBy('date', 'desc')
      .limit(querySize)
      .get()
      .then(snapshot => resolve(snapshot.docs.map(doc => doc.data()['query'])))
      .catch(error => reject(error))
  )

exports.getAppsBySearchDate = () =>
  new Promise((resolve, reject) =>
    db
      .collection('app')
      .orderBy('searchDate', 'desc')
      .limit(querySize * 2)
      .get()
      .then(snapshot => resolve(snapshot.docs.map(doc => doc.data())))
      .catch(error => reject(error))
  )

exports.getAppsByReleaseDate = () =>
  new Promise((resolve, reject) =>
    db
      .collection('app')
      .orderBy('currentVersionReleaseDate', 'desc')
      .limit(querySize)
      .get()
      .then(snapshot => resolve(snapshot.docs.map(doc => doc.data())))
      .catch(error => reject(error))
  )

exports.incrementAppViewCount = trackId => {
  const ref = db.collection('app').doc(trackId)
  let newViewCount
  return new Promise((resolve, reject) =>
    db
      .runTransaction(transaction =>
        transaction.get(ref).then(doc => {
          const viewCount = doc.data().viewCount
          newViewCount = isNaN(viewCount) ? 1 : viewCount + 1
          return transaction.update(ref, { viewCount: newViewCount })
        })
      )
      .then(() => resolve(newViewCount))
      .catch(error => reject(error))
  )
}

exports.getMostViewedApps = () =>
  new Promise((resolve, rejcet) => {
    db.collection('app')
      .orderBy('viewCount', 'desc')
      .limit(querySize)
      .get()
      .then(snapshot => resolve(snapshot.docs.map(doc => doc.data())))
      .catch(error => rejcet(error))
  })

exports.getAppsForGenre = genre =>
  new Promise((resolve, reject) =>
    db
      .collection('app')
      .where('primaryGenreName', '==', genre)
      .orderBy('searchDate', 'desc')
      .limit(querySize * 2)
      .get()
      .then(snapshot => resolve(snapshot.docs.map(doc => doc.data())))
      .catch(error => reject(error))
  )

exports.deleteDatabase = () => {
  return Promise.all([deleteCollection('app'), deleteCollection('search')])
}

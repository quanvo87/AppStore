const admin = require('firebase-admin')
const db = require('../index').db

const querySize = 20

exports.saveSearchHistory = (uid, query) =>
  db
    .collection('user')
    .doc(uid)
    .collection('searchHistory')
    .add({
      query: query,
      date: admin.firestore.FieldValue.serverTimestamp()
    })

exports.saveApps = apps => {
  const batch = db.batch()
  apps.forEach(app =>
    batch.set(db.collection('app').doc(app['trackId'].toString()), app, {
      merge: true
    })
  )
  return batch.commit()
}

exports.getRecentSearches = uid =>
  new Promise((resolve, reject) =>
    db
      .collection('user')
      .doc(uid)
      .collection('searchHistory')
      .orderBy('date', 'desc')
      .get()
      .then(snapshot => {
        const recentSearches = []
        snapshot.forEach(doc => recentSearches.push(doc.data()['query']))
        return resolve(recentSearches)
      })
      .catch(error => reject(error))
  )

exports.getNewestApps = () =>
  new Promise((resolve, reject) =>
    db
      .collection('app')
      .orderBy('currentVersionReleaseDate', 'desc')
      .limit(querySize)
      .get()
      .then(snapshot => {
        const newestApps = []
        snapshot.forEach(doc => newestApps.push(doc.data()))
        return resolve(newestApps)
      })
      .catch(error => reject(error))
  )

exports.getAppsForGenre = genre =>
  new Promise((resolve, reject) =>
    db
      .collection('app')
      .where('primaryGenreName', '==', genre)
      .limit(querySize)
      .get()
      .then(snapshot => {
        const apps = []
        snapshot.forEach(doc => apps.push(doc.data()))
        return resolve(apps)
      })
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

exports.getPopularApps = () =>
  new Promise((resolve, rejcet) => {
    db.collection('app')
      .orderBy('viewCount', 'desc')
      .limit(querySize)
      .get()
      .then(snapshot => {
        const apps = []
        snapshot.forEach(doc => apps.push(doc.data()))
        return resolve(apps)
      })
      .catch(error => rejcet(error))
  })

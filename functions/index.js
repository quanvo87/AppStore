const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.db = admin.firestore()
exports.db.settings({ timestampsInSnapshots: true })
const dbUtil = require('./util/dbUtil')

const axios = require('axios')

const querySize = '20'
const searchUrl =
  'https://itunes.apple.com/search?entity=software&limit=' +
  querySize +
  '&term='

exports.search = functions.https.onRequest((req, res) => {
  const uid = req.query.uid
  const query = req.query.query
  const saveSearch = req.query.saveSearch
  if (saveSearch === 'true') dbUtil.saveSearchHistory(uid, query)
  const url = searchUrl + query
  return axios
    .get(url)
    .then(searchResponse => res.send(searchResponse.data.results))
    .catch(error => {
      console.log(error)
      return res.status(400).end()
    })
})

exports.onSearch = functions.firestore
  .document('user/{uid}/searchHistory/{docId}')
  .onCreate(snap => {
    const query = snap.data().query
    const url = searchUrl + query
    return axios
      .get(url)
      .then(searchResponse => dbUtil.saveApps(searchResponse.data.results))
      .catch(error => {
        console.log(error)
        return res.status(400).end()
      })
  })

exports.recentSearches = functions.https.onRequest((req, res) => {
  const uid = req.query.uid
  return dbUtil
    .getRecentSearches(uid)
    .then(recentSearches => res.send(recentSearches))
    .catch(error => {
      console.log(error)
      return res.status(400).end()
    })
})

exports.newestApps = functions.https.onRequest((_, res) =>
  dbUtil
    .getNewestApps()
    .then(newestApps => res.send(newestApps))
    .catch(error => {
      console.log(error)
      return res.status(400).end()
    })
)

exports.appGenres = functions.https.onRequest((_, res) =>
  res.send(require('./util/appGenres').appGenres)
)

exports.appsForGenre = functions.https.onRequest((req, res) => {
  const genre = req.query.genre
  return dbUtil
    .getAppsForGenre(genre)
    .then(apps => res.send(apps))
    .catch(error => {
      console.log(error)
      return res.status(400).end()
    })
})

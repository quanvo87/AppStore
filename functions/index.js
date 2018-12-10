const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.db = admin.firestore()
exports.db.settings({ timestampsInSnapshots: true })
const dbUtil = require('./util/dbUtil')

const axios = require('axios')

const querySize = '50'
const searchUrl =
  'https://itunes.apple.com/search?entity=software&limit=' +
  querySize +
  '&term='

exports.search = functions.https.onRequest((req, res) => {
  const query = req.query.query
  const saveSearch = req.query.saveSearch
  if (saveSearch === 'true') dbUtil.saveSearch(query)
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
  .document('search/{docId}')
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

exports.recentSearches = functions.https.onRequest((_, res) =>
  dbUtil
    .getRecentSearches()
    .then(recentSearches => res.send(recentSearches))
    .catch(error => {
      console.log(error)
      return res.status(400).end()
    })
)

exports.appsBySearchDate = functions.https.onRequest((_, res) =>
  dbUtil
    .getAppsBySearchDate()
    .then(apps => res.send(apps))
    .catch(error => {
      console.log(error)
      return res.status(400).end()
    })
)

exports.appsByReleaseDate = functions.https.onRequest((_, res) =>
  dbUtil
    .getAppsByReleaseDate()
    .then(apps => res.send(apps))
    .catch(error => {
      console.log(error)
      return res.status(400).end()
    })
)

exports.incrementAppViewCount = functions.https.onRequest((req, res) => {
  const trackId = req.query.trackId
  return dbUtil
    .incrementAppViewCount(trackId)
    .then(newViewCount => res.send(String(newViewCount)))
    .catch(error => {
      console.log(error)
      return res.status(400).end()
    })
})

exports.mostViewedApps = functions.https.onRequest((_, res) =>
  dbUtil
    .getMostViewedApps()
    .then(apps => res.send(apps))
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

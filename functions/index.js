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
  const url = searchUrl + query
  dbUtil.saveSearchHistory(uid, query)
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
  .onCreate((snap) => {
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
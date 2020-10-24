import * as firebase from '@firebase/rules-unit-testing'
import 'jest'

describe('user-book', function () {
  const collection = 'user-books'
  const projectId = 'user-book-spec'
  const uid = '123'
  const uid2 = '456'

  var appAdmin: firebase.firestore.Firestore
  var appTest: firebase.firestore.Firestore
  var userBook: firebase.firestore.DocumentReference<firebase.firestore.DocumentData>

  afterEach(async () => {
    await Promise.all(firebase.apps().map(async (app) => await app.delete()))
    await firebase.clearFirestoreData({ projectId })
  })

  describe('with auth', () => {
    beforeEach(async () => {
      appTest = firebase.initializeTestApp({ auth: { uid }, projectId }).firestore()
      userBook = appTest.collection(collection).doc(uid)
    })

    describe('set', () => {
      it('succeeds with same uid', () => firebase.assertSucceeds(userBook.set({})))
      it('fails with different uid', async () => {
        const another = appTest.collection(collection).doc(uid2)
        await firebase.assertFails(another.set({}))
      })
    })

    describe('same uid', () => {
      beforeEach(async () => {
        appAdmin = firebase.initializeAdminApp({ projectId }).firestore()
        await appAdmin.collection(collection).doc(uid).set({})
      })

      it('get succeeds', () => firebase.assertSucceeds(userBook.get()))
      it('update succeeds', () => firebase.assertSucceeds(userBook.update({})))
      it('delete fails', () => firebase.assertFails(userBook.delete()))
    })

    describe('different uid', () => {
      beforeEach(async () => {
        userBook = appTest.collection(collection).doc(uid2)

        const adminApp = firebase.initializeAdminApp({ projectId })
        await adminApp.firestore().collection(collection).doc(uid2).set({})
      })

      it('get fails', () => firebase.assertFails(userBook.get()))
      it('update fails', () => firebase.assertFails(userBook.update({})))
      it('delete fails', () => firebase.assertFails(userBook.delete()))
    })
  })

  describe('without auth', () => {
    beforeEach(() => {
      appTest = firebase.initializeTestApp({ projectId }).firestore()
      userBook = appTest.collection(collection).doc(uid)
    })

    it('set fails', () => firebase.assertFails(userBook.set({})))

    describe('existing data', () => {
      beforeEach(async () => {
        appAdmin = firebase.initializeAdminApp({ projectId }).firestore()
        await appAdmin.collection(collection).doc(uid).set({})
      })

      it('get fails', () => firebase.assertFails(userBook.get()))
      it('update fails', () => firebase.assertFails(userBook.update({})))
      it('delete fails', () => firebase.assertFails(userBook.delete()))
    })
  })
})

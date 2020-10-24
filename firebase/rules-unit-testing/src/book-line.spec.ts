import * as firebase from '@firebase/rules-unit-testing'
import 'jest'

describe('book', function () {
  const bookId = 'abc'
  const collectionBook = 'books'
  const collectionLine = 'lines'
  const lineId = 'abc123'
  const projectId = 'book-line-spec'
  const roleEditor = 'editor'
  const roleOwner = 'owner'
  const roleViewer = 'viewer'
  const uid = '123'

  var appAdmin: firebase.firestore.Firestore
  var appTest: firebase.firestore.Firestore
  var bookLine: firebase.firestore.DocumentReference<firebase.firestore.DocumentData>

  afterEach(async () => {
    await Promise.all(firebase.apps().map(async (app) => await app.delete()))
    await firebase.clearFirestoreData({ projectId })
  })

  describe('with auth', () => {
    beforeEach(async () => {
      appTest = firebase.initializeTestApp({ auth: { uid }, projectId }).firestore()
      appAdmin = firebase.initializeAdminApp({ projectId }).firestore()

      bookLine = appTest.collection(collectionBook).doc(bookId).collection(collectionLine).doc(lineId)
    })

    describe('owner', () => {
      beforeEach(async () => {
        appAdmin = firebase.initializeAdminApp({ projectId }).firestore()
        await appAdmin.collection(collectionBook).doc(bookId).set({ roles: { [uid]: roleOwner } })
      })

      it('set succeeds', () => firebase.assertSucceeds(bookLine.set({})))

      describe('existing data', () => {
        beforeEach(async () => {
          await appAdmin.collection(collectionBook).doc(bookId).collection(collectionLine).doc(lineId).set({})
        })

        it('get succeeds', () => firebase.assertSucceeds(bookLine.get()))
        it('update fails', () => firebase.assertFails(bookLine.update({})))
        it('delete fails', () => firebase.assertFails(bookLine.delete()))
      })
    })

    describe('viewer', () => {
      beforeEach(async () => {
        appAdmin = firebase.initializeAdminApp({ projectId }).firestore()
        await appAdmin.collection(collectionBook).doc(bookId).set({ roles: { [uid]: roleViewer } })
      })

      it('set fails', () => firebase.assertFails(bookLine.set({})))

      describe('existing data', () => {
        beforeEach(async () => {
          await appAdmin.collection(collectionBook).doc(bookId).collection(collectionLine).doc(lineId).set({})
        })

        it('get succeeds', () => firebase.assertSucceeds(bookLine.get()))
        it('update fails', () => firebase.assertFails(bookLine.update({})))
        it('delete fails', () => firebase.assertFails(bookLine.delete()))
      })
    })

    describe('editor', () => {
      beforeEach(async () => {
        appAdmin = firebase.initializeAdminApp({ projectId }).firestore()
        await appAdmin.collection(collectionBook).doc(bookId).set({ roles: { [uid]: roleEditor } })
      })

      it('set succeeds', () => firebase.assertSucceeds(bookLine.set({})))

      describe('existing data', () => {
        beforeEach(async () => {
          await appAdmin.collection(collectionBook).doc(bookId).collection(collectionLine).doc(lineId).set({})
        })

        it('get succeeds', () => firebase.assertSucceeds(bookLine.get()))
        it('update fails', () => firebase.assertFails(bookLine.update({})))
        it('delete fails', () => firebase.assertFails(bookLine.delete()))
      })
    })
  })

  describe('without auth', () => {
    beforeEach(async () => {
      appTest = firebase.initializeTestApp({ projectId }).firestore()
      bookLine = appTest.collection(collectionBook).doc(bookId).collection(collectionLine).doc(lineId)

      appAdmin = firebase.initializeAdminApp({ projectId }).firestore()
      await appAdmin.collection(collectionBook).doc(bookId).set({
        roles: { [uid]: roleOwner }
      })
    })

    it('set fails', () => firebase.assertFails(bookLine.set({})))

    describe('existing data', () => {
      beforeEach(async () => {
        await appAdmin.collection(collectionBook).doc(bookId).collection(collectionLine).doc(lineId).set({})
      })

      it('get fails', () => firebase.assertFails(bookLine.get()))
      it('update fails', () => firebase.assertFails(bookLine.update({})))
      it('delete fails', () => firebase.assertFails(bookLine.delete()))
    })
  })
})

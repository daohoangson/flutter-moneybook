import * as firebase from '@firebase/rules-unit-testing'
import 'jest'

describe('book', function () {
  const bookId = 'abc'
  const collection = 'books'
  const collectionUserBook = 'user-books'
  const projectId = 'book-spec'
  const roleEditor = 'editor'
  const roleOwner = 'owner'
  const roleViewer = 'viewer'
  const uid = '123'
  const uid2 = '456'

  var appAdmin: firebase.firestore.Firestore
  var appTest: firebase.firestore.Firestore
  var book: firebase.firestore.DocumentReference<firebase.firestore.DocumentData>

  afterEach(async () => {
    await Promise.all(firebase.apps().map(async (app) => await app.delete()))
    await firebase.clearFirestoreData({ projectId })
  })

  describe('with auth', () => {
    var userBook: firebase.firestore.DocumentReference<firebase.firestore.DocumentData>

    beforeEach(async () => {
      appTest = firebase.initializeTestApp({ auth: { uid }, projectId }).firestore()
      book = appTest.collection(collection).doc(bookId)
      userBook = appTest.collection(collectionUserBook).doc(uid)
    })

    describe('set', () => {
      it('succeeds with owner role', async () => {
        await firebase.assertSucceeds(appTest.runTransaction(async (transaction) => {
          transaction.set(userBook, { [bookId]: roleOwner })
          transaction.set(book, { roles: { [uid]: roleOwner } })
        }))
      })

      it('fails with non-owner role', () => {
        firebase.assertFails(appTest.runTransaction(async (transaction) => {
          transaction.set(userBook, { [bookId]: 'xxx' })
          transaction.set(book, { roles: { [uid]: 'xxx' } })
        }))
      })

      it('fails without user book', () => firebase.assertFails(book.set({ roles: { [uid]: roleOwner } })))
    })

    describe('owner', () => {
      beforeEach(async () => {
        appAdmin = firebase.initializeAdminApp({ projectId }).firestore()
        await appAdmin.collection(collection).doc(bookId).set({ roles: { [uid]: roleOwner } })
      })

      it('get succeeds', () => firebase.assertSucceeds(book.get()))
      it('update succeeds', () => firebase.assertSucceeds(book.update({ balance: 0 })))
      it('update roles succeeds', () => firebase.assertSucceeds(book.update({
        roles: {
          [uid]: roleOwner,
          [uid2]: roleEditor
        }
      })))
      it('delete fails', () => firebase.assertFails(book.delete()))
    })

    describe('viewer', () => {
      beforeEach(async () => {
        appAdmin = firebase.initializeAdminApp({ projectId }).firestore()
        await appAdmin.collection(collection).doc(bookId).set({ roles: { [uid]: roleViewer } })
      })

      it('get succeeds', () => firebase.assertSucceeds(book.get()))
      it('update fails', () => firebase.assertFails(book.update({ balance: 0 })))
      it('delete fails', () => firebase.assertFails(book.delete()))
    })

    describe('editor', () => {
      beforeEach(async () => {
        appAdmin = firebase.initializeAdminApp({ projectId }).firestore()
        await appAdmin.collection(collection).doc(bookId).set({ roles: { [uid]: roleEditor } })
      })

      it('get succeeds', () => firebase.assertSucceeds(book.get()))
      it('update succeeds', () => firebase.assertSucceeds(book.update({ balance: 0 })))
      it('update roles fails', () => firebase.assertFails(book.update({ roles: { [uid]: roleOwner } })))
      it('delete fails', () => firebase.assertFails(book.delete()))
    })
  })

  describe('without auth', () => {
    beforeEach(() => {
      appTest = firebase.initializeTestApp({ projectId }).firestore()
      book = appTest.collection(collection).doc(bookId)
    })

    it('set fails', () => firebase.assertFails(book.set({})))

    describe('existing data', () => {
      beforeEach(async () => {
        appAdmin = firebase.initializeAdminApp({ projectId }).firestore()
        await appAdmin.collection(collection).doc(bookId).set({
          roles: { [uid]: roleOwner }
        })
      })

      it('get fails', () => firebase.assertFails(book.get()))
      it('update fails', () => firebase.assertFails(book.update({})))
      it('delete fails', () => firebase.assertFails(book.delete()))
    })
  })
})

const { assert } = require('chai')
// const { assertRevert } = require('@aragon/contract-test-helpers/assertThrow')
const { newDao, newApp } = require('./helpers/dao')
const { setOpenPermission } = require('./helpers/permissions')

const Wiki = artifacts.require('Wiki.sol')

contract('Wiki pages', ([appManager, user]) => {

  let appBase, app

  before('deploy base app', async () => {
    // Deploy the app's base contract.
    appBase = await Wiki.new()
  })

  beforeEach('deploy dao and app', async () => {
    const { dao, acl } = await newDao(appManager)

    // Instantiate a proxy for the app, using the base contract as its logic implementation.
    const proxyAddress = await newApp(dao, 'wiki', appBase.address, appManager)
    app = await Wiki.at(proxyAddress)

    // Set up the app's permissions.
    await setOpenPermission(acl, app.address, await app.CREATE_PAGE_ROLE(), appManager)
    await setOpenPermission(acl, app.address, await app.EDIT_PAGE_ROLE(), appManager)
    await setOpenPermission(acl, app.address, await app.DELETE_PAGE_ROLE(), appManager)

    // Initialize the app's proxy.
    await app.initialize()
  })

  it('should be created by any address', async () => {
    await app.createPage("0x0", { from: user })
    assert.equal(await app.nextId(), 1)
  })

  it('should be edited by any address', async () => {
    await app.editPage(0, "0x1")
  })
})

import Foundation
@testable import KVStoreCore
import XCTest

class KVStoreTests: XCTestCase {
  
  var sut: KVStore!
  
  override func setUp() {
    super.setUp()
    
    sut = KVStore()
  }
  
  func testNestedTransactionCommit_SavesChangesToParent() {
    
    // Given initial values
    sut._transaction(Command.set(key: "foo", value: "123"))
    sut._transaction(Command.set(key: "bar", value: "abc"))
    
    // When a nested transaction is commited
    sut._transaction(Command.begin)
    sut._transaction(Command.set(key: "foo", value: "456"))
    sut._transaction(Command.set(key: "bar", value: "def"))
    sut._transaction(Command.commit)
    
    // Then the store will be equal to the modified values
    XCTAssertEqual(sut.store, ["foo":"456", "bar":"def"])
  }
  
  func testNestedTransactionRollback_DiscardsChanges() {
    
    // Given initial values
    sut._transaction(Command.set(key: "foo", value: "123"))
    sut._transaction(Command.set(key: "bar", value: "abc"))
    
    // When a nested transaction is rolled back
    sut._transaction(Command.begin)
    sut._transaction(Command.set(key: "foo", value: "456"))
    sut._transaction(Command.set(key: "bar", value: "def"))
    sut._transaction(Command.rollback)
    
    // Then the store will be equal to it's initial values
    XCTAssertEqual(sut.store, ["foo":"123", "bar":"abc"])
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
}

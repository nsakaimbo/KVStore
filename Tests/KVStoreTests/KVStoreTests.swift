import Foundation
@testable import KVStoreCore
import XCTest

class KVStoreTests: XCTestCase {
  
  var sut: KVStore!
  var mockIO: MockIO!
  
  override func setUp() {
    super.setUp()
    
    mockIO = MockIO()
    sut = KVStore()
    
    sut.consoleIO = mockIO
  }
  
  func testNestedTransactionCommit_SavesChangesToParent() {
    
    // Given
    var initial: KVStore.StoreType = _initial
    let modified: KVStore.StoreType = initial.merged(with: _modified)
    
    // When the initial input is merged with a nested transaction that is committed
    mockIO.input = "commit"
    initial.merge(with: sut._transaction(modified, nested: true))
    
    // Then the intial input will be modified
    XCTAssertEqual(initial, modified)
  }
  
  
  func testNestedTransactionRollback_DiscardsChanges() {
    
    // Given
    var initial: KVStore.StoreType = _initial
    let modified: KVStore.StoreType = initial.merged(with: _modified)
    
    // When the initial input is merged with a nested transaction that is rolled back
    mockIO.input = "rollback"
    initial.merge(with: sut._transaction(modified, nested: true))
    
    // Then the initial input will remain unchanged
    XCTAssertEqual(initial, _initial)
  }
  
  override func tearDown() {
    sut = nil
    mockIO = nil
    
    super.tearDown()
  }
}

extension KVStoreTests {
  
  class MockIO: IOProvider {
    
    var input: String = ""
    
    func getInput() -> String {
      return input
    }
  }
  
  // Represents initial input to the KVStore
  var _initial: KVStore.StoreType {
    return ["abc":"123",
            "bar":"abc"]
  }
  
  // Represents changes to the KVStore after a sequence of SET and DELETE operations
  var _modified: KVStore.StoreType {
    return ["foo":"456",
            "bar":"def"]
  }
}

//
//  Stack.swift
//  KVStore
//
//  Created by Nicholas Sakaimbo on 5/19/17.
//
//

import Foundation

struct Stack<T>{
  
  fileprivate var _array: Array<T> = []
  
  func first() -> T? {
    return _array.last
  }
  
  var isEmpty: Bool {
    return _array.count == 0
  }
  
  var count: Int {
    return _array.count
  }
  
  mutating func push(_ element: T) {
    _array.append(element)
  }
  
  mutating func pop() -> T? {
    
    guard !_array.isEmpty else {
      return nil
    }
    return _array.popLast()
  }
}

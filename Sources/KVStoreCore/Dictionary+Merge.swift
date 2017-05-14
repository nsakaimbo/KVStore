//
//  Dictionary+Merge.swift
//  KVStore
//
//  Created by Nicholas Sakaimbo on 5/13/17.
//
//

import Foundation

extension Dictionary {
  
  /// Merges another dictionary in-place
  ///
  /// - Parameter dictionary: A dictionary with the same `Key` and `Value` types as the receiver.
  mutating func merge(with dictionary: Dictionary<Key,Value>) {
    
    for (key, value) in dictionary {
      self[key] = value
    }
  }
}

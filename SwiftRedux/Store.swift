//
//  Store.swift
//  TO-DO_v2
//
//  Created by mert.kutluca on 3.07.2022.
//

import Foundation

public protocol Action {}

public protocol State {}

public typealias Reducer<StateType: State> = (_ action: Action, _ state: StateType?) -> StateType

final public class Store<StateType: State> {
    private let reducer: Reducer<StateType>
    private var state: StateType?
    private var subscribers: [AnyStoreSubscriber] = []

    public init(reducer: @escaping Reducer<StateType>, state: StateType?) {
        self.reducer = reducer
        self.state = state
    }

    public func dispatch(_ action: Action) {
        state = reducer(action, state)
        subscribers.forEach { $0._newState(state: state!) }
    }

    public func subscribe(_ newSubscriber: AnyStoreSubscriber) {
        subscribers.append(newSubscriber)
        subscribers.forEach { $0._newState(state: state!) }
    }
    
    public func unsubscribe(_ subscriber: AnyStoreSubscriber) {
     for (index, value ) in subscribers.enumerated() where value === subscriber {
      if index < subscribers.count {
        self.subscribers.remove(at: index)
      }
    }
  }
}

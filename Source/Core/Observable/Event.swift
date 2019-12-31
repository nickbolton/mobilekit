import Foundation

public class ImmutableEvent<T> {
  
  public typealias Handler = (T, T?) -> Void
  
  fileprivate var observers: [Int: (Handler, DispatchQueue?)] = [:]
  private var uniqueID = (0...).makeIterator()
  
  fileprivate let lock: Lock = Mutex()
  
  fileprivate var _onDispose: () -> Void
  
  public init(_ onDispose: @escaping () -> Void = {}) {
    self._onDispose = onDispose
  }
  
  public func observe(_ queue: DispatchQueue? = nil, _ observer: @escaping Handler) -> Disposable {
    lock.lock()
    defer { lock.unlock() }
    
    let id = uniqueID.next()!
    
    observers[id] = (observer, queue)

    let disposable = Disposable { [weak self] in
      self?.observers[id] = nil
      self?._onDispose()
    }
    
    return disposable
  }
  
  public func removeAllObservers() {
    observers.removeAll()
  }
  
  public func asImmutable() -> ImmutableEvent<T> {
    return self
  }
}

public class Event<T>: ImmutableEvent<T> {
  
  public func update(value: T, oldValue: T? = nil) {
    observers.values.forEach { observer, dispatchQueue in
      if let dispatchQueue = dispatchQueue {
        dispatchQueue.async { observer(value, oldValue) }
      } else {
        observer(value, oldValue)
      }
    }
  }
}

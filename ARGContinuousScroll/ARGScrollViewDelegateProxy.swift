//
//  ARGScrollViewDelegateProxy.swift
//  ARGContinuousScroll
//
//  Created by Sergei Polshcha on 21.10.2020.
//

import UIKit

class Weak<T: AnyObject> {
    
    weak var value : T?
    
    init (_ value: T) {
        self.value = value
    }
    
}

extension Array where Element: Weak<AnyObject> {
    
    mutating func clean () {
        self = self.filter { nil != $0.value }
    }
    
}

public class ARGScrollViewDelegateProxy: NSObject, UIScrollViewDelegate {
    
    var delegates: [Weak<NSObject & UIScrollViewDelegate>] = [Weak<NSObject & UIScrollViewDelegate>]()
    
    public func addDelegate(_ delegate: (NSObject & UIScrollViewDelegate)?) {
        if delegate != nil {
            delegates.append(Weak(delegate!))
        }
    }
    
    public func removeDelegate(_ delegate: UIScrollViewDelegate) {
        delegates = delegates.filter {!($0.value?.isEqual(delegate) ?? false)}
    }
    
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        for delegate in delegates {
            if let value = delegate.value {
                if value.responds(to: aSelector) {
                    return delegate.value
                }
            }
        }
        
        return super.forwardingTarget(for: aSelector)
    }
    
    public override func responds(to aSelector: Selector!) -> Bool {
       // return true

        for delegate in delegates {
            if let value = delegate.value {
                if value.responds(to: aSelector) {
                    return true
                }
            }
        }

        return false
    }
    
}

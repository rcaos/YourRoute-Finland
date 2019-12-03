//
//  Bindable.swift
//  YourRoute
//
//  Created by Jeans on 11/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

class Bindable<T>{
    typealias Listener = (T)->Void
    var listener: Listener?
    
    var value:T{
        didSet{
            listener?(value)
        }
    }
    
    init(_ v: T){
        self.value = v
    }
    
    func bind(_ listener: Listener?){
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?){
        self.listener = listener
        listener?(value)
    }
    
}

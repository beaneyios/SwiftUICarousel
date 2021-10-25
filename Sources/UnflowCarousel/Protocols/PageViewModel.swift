//
//  File.swift
//  
//
//  Created by Matt Beaney on 25/10/2021.
//

import SwiftUI

public protocol PageViewModel {
    var backgroundImage: Image { get }
    var backgroundColor: Color { get }
    var title: String { get }
    var summary: String { get }
    var buttonTitle: String { get }
}

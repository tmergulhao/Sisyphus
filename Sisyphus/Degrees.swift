//
//  Degrees.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 21/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import Foundation

typealias Degrees = CGFloat

let π = CGFloat(M_PI)

extension CGFloat {
	var radians : CGFloat { return π * self / 180.0 }
	var degrees : CGFloat { return 180.0 * self / π }
}

//Created by Lugalu on 16/06/24.

import Foundation

func clamp<T:Numeric & Comparable>(minValue:T, value:T, maxValue:T) -> T {
    return min(maxValue, max(minValue, value))
}

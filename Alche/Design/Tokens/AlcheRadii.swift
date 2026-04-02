import SwiftUI

enum AlcheRadii {
    /// 2pt -- sharp corners, default for everything (editorial aesthetic)
    static let sm: CGFloat = 2

    /// 2pt -- same as sm, sharp is the default
    static let md: CGFloat = 2

    /// 2pt -- same as sm, sharp is the default
    static let lg: CGFloat = 2

    /// 4pt -- text fields only, slight softness for input affordance
    static let input: CGFloat = 4

    /// 9999pt -- pills, avatars, circular elements
    static let full: CGFloat = 9999
}

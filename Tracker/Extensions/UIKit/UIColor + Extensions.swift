import UIKit

extension UIColor {
    // Colors application
    static var appBlack: UIColor {
        UIColor { (traits) -> UIColor in
            traits.userInterfaceStyle == .light ?
            UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00) :
            UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        }
    }
    static var appWhite: UIColor {
        UIColor { (traits) -> UIColor in
            traits.userInterfaceStyle == .light ?
            UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00) :
            UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        }
    }
    static var appBackground: UIColor {
        UIColor { (traits) -> UIColor in
            traits.userInterfaceStyle == .light ?
            UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30) :
            UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.85)
        }
    }
    static let appGray = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
    static let appLightGray = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.00)
    static let appRed = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00)
    static let appBlue = UIColor(red: 0.22, green: 0.45, blue: 0.91, alpha: 1.00)
    static let gradientRed = UIColor(red: 0.99, green: 0.29, blue: 0.28, alpha: 1.00)
    static let gradientBlue = UIColor(red: 0.00, green: 0.48, blue: 0.98, alpha: 1.00)
    static let gradientGreen = UIColor(red: 0.27, green: 0.90, blue: 0.62, alpha: 1.00)
    
    // Colors selection
    static let colorSelection1 = UIColor(red: 0.99, green: 0.30, blue: 0.29, alpha: 1.00)
    static let colorSelection2 = UIColor(red: 1.00, green: 0.53, blue: 0.12, alpha: 1.00)
    static let colorSelection3 = UIColor(red: 0.00, green: 0.48, blue: 0.98, alpha: 1.00)
    static let colorSelection4 = UIColor(red: 0.43, green: 0.27, blue: 1.00, alpha: 1.00)
    static let colorSelection5 = UIColor(red: 0.20, green: 0.81, blue: 0.41, alpha: 1.00)
    static let colorSelection6 = UIColor(red: 0.90, green: 0.43, blue: 0.83, alpha: 1.00)
    static let colorSelection7 = UIColor(red: 0.98, green: 0.83, blue: 0.83, alpha: 1.00)
    static let colorSelection8 = UIColor(red: 0.20, green: 0.65, blue: 1.00, alpha: 1.00)
    static let colorSelection9 = UIColor(red: 0.27, green: 0.90, blue: 0.62, alpha: 1.00)
    static let colorSelection10 = UIColor(red: 0.21, green: 0.20, blue: 0.49, alpha: 1.00)
    static let colorSelection11 = UIColor(red: 1.00, green: 0.40, blue: 0.30, alpha: 1.00)
    static let colorSelection12 = UIColor(red: 1.00, green: 0.60, blue: 0.80, alpha: 1.00)
    static let colorSelection13 = UIColor(red: 0.96, green: 0.77, blue: 0.55, alpha: 1.00)
    static let colorSelection14 = UIColor(red: 0.47, green: 0.58, blue: 0.96, alpha: 1.00)
    static let colorSelection15 = UIColor(red: 0.51, green: 0.17, blue: 0.95, alpha: 1.00)
    static let colorSelection16 = UIColor(red: 0.68, green: 0.34, blue: 0.85, alpha: 1.00)
    static let colorSelection17 = UIColor(red: 0.55, green: 0.45, blue: 0.90, alpha: 1.00)
    static let colorSelection18 = UIColor(red: 0.18, green: 0.82, blue: 0.35, alpha: 1.00)
}

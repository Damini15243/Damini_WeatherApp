//
//  FormatStyle.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import UIKit

// MARK: - Fonts

extension UIFont {

    enum FontType: String {
        case regular                 = "SofiaProSoftW01-Regular"
        case bold                    = "#9Slide03SofiaProSoft-Bold"
        case sfProRegular            = "SFProText-Regular"
        case spProSemibold               = "SFProText-Semibold"
    }

    /// Set custom font
    /// - Parameters:
    ///   - type: Font type.
    ///   - size: Size of font.
    ///   - isRatio: Whether set font size ratio or not. Default true.
    /// - Returns: Return font.
    class func customFont(ofType type: FontType, withSize size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size * ScreenSize.fontAspectRatio) ?? UIFont.systemFont(ofSize: size)
    }
}

// MARK: - Screen resolution
struct ScreenSize {
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }

    static var baseScreenWidth: CGFloat {
        return 375.0
    }

    static var baseScreenHeight: CGFloat {
        return 812.0
    }

    static var heightAspectRatio: CGFloat {
        return UIScreen.main.bounds.size.height / 667
    }

    static var widthAspectRatio: CGFloat {
        return UIScreen.main.bounds.size.width / 375
    }

    static var aspectRatio: CGFloat {
        return (self.heightAspectRatio / self.widthAspectRatio).rounded()
    }

    static var fontAspectRatio: CGFloat {
        // Check for iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIScreen.main.bounds.size.height / 667
        }

        // Get the current window scene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            // Default fallback if there's no window scene
            return UIScreen.main.bounds.size.width / 375
        }

        // Get the current interface orientation
        let isPortrait = windowScene.interfaceOrientation.isPortrait

        let size = UIScreen.main.bounds.size
        if isPortrait { // Portrait
            return size.width / 375
        } else { // Landscape
            return size.height / 375
        }
    }

    static var cornerRadious: CGFloat {
        return 10
    }
}

// MARK: - Date Formate

extension String {
    func formatDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Input format

        // Convert the string to Date
        if let date = dateFormatter.date(from: self) {
            // Set the desired output format
            dateFormatter.dateFormat = "d" // Day of the month
            let dayString = dateFormatter.string(from: date)

            // Get the weekday name
            dateFormatter.dateFormat = "EEEE" // Full weekday name
            let weekdayString = dateFormatter.string(from: date)

            // Get the ordinal suffix for the day
            let suffix = ordinalSuffix(for: Int(dayString) ?? 0)

            return "\(dayString)\(suffix) \(weekdayString)"
        }
        return self // Fallback if conversion fails
    }

    func ordinalSuffix(for day: Int) -> String {
        switch day {
        case 11, 12, 13:
            return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
}

// MARK: - Dynamic Table (Use when table is needed in scrollView)
class DynamicTableView: UITableView {

    override var contentSize: CGSize {
        didSet {
            if contentSize == CGSize(width: ScreenSize.width, height: 0.0) {
                self.separatorStyle = .none
                contentSize = CGSize(width: ScreenSize.width, height: 10.0)
            } else {
                self.invalidateIntrinsicContentSize()
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

extension UIViewController {
    func presentAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
            // Call the completion handler if provided
            completion?()
        }

        alert.addAction(okayAction)

        self.present(alert, animated: true, completion: nil)
    }
}

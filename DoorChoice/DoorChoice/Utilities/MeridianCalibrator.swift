import SpriteKit
import UIKit

// MARK: - Screen Calibration Utility
struct MeridianCalibrator {

    static var canvasExtent: CGSize {
        let screenBounds = UIScreen.main.bounds
        return CGSize(width: screenBounds.width, height: screenBounds.height)
    }

    static var scaleFraction: CGFloat {
        let baseWidth: CGFloat = 375.0
        return min(canvasExtent.width / baseWidth, 1.4)
    }

    static var isTabletVessel: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    static func proportionalValue(_ baseValue: CGFloat) -> CGFloat {
        return baseValue * scaleFraction
    }

    static func doorColumnsForStage(_ portalCount: Int) -> Int {
        if portalCount <= 3 { return portalCount }
        if portalCount <= 6 { return 3 }
        return 4
    }

    static func portalDimension(forCount portalCount: Int) -> CGSize {
        let availableWidth = canvasExtent.width - proportionalValue(40)
        let columns = CGFloat(doorColumnsForStage(portalCount))
        let spacing = proportionalValue(12)
        let doorWidth = min((availableWidth - spacing * (columns + 1)) / columns, proportionalValue(140))
        let doorHeight = doorWidth * 1.4
        return CGSize(width: doorWidth, height: doorHeight)
    }

    static func safeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 15.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                return window.safeAreaInsets
            }
        } else {
            if let window = UIApplication.shared.windows.first {
                return window.safeAreaInsets
            }
        }
        return .zero
    }

    static var topSafeMargin: CGFloat {
        return safeAreaInsets().top
    }

    static var bottomSafeMargin: CGFloat {
        return safeAreaInsets().bottom
    }
}

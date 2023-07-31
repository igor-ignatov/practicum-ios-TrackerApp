import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {
    
    func testLigthTrackersViewController() throws {
        let vc = AppTabBarController()
        assertSnapshot(
            matching: vc,
            as: .image(
                traits: .init(
                    userInterfaceStyle: .light
                )
            )
        )
    }
    
    func testDarkTrackersViewController() throws {
        let vc = AppTabBarController()
        assertSnapshot(
            matching: vc,
            as: .image(
                traits: .init(
                    userInterfaceStyle: .dark
                )
            )
        )
    }
}

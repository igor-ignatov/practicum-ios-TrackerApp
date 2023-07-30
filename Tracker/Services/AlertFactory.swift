import UIKit

protocol AlertFactoryProtocol {
    func makeAlertConfirmingDeletion(completion: @escaping () -> Void) -> UIAlertController
}

final class AlertFactory: AlertFactoryProtocol {
    
    static let shared: AlertFactoryProtocol = AlertFactory()
    
    private init() {}
    
    func makeAlertConfirmingDeletion(completion: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: NSLocalizedString("trackers.alertTitle", comment: "Deleting tracker title"),
            message: nil,
            preferredStyle: .actionSheet
        )
        let deleteAction = UIAlertAction(
            title: NSLocalizedString("trackers.alertDeleteButton", comment: "Delete button text"),
            style: .destructive
        ) { _ in
            completion()
        }
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("trackers.alertCancelButton", comment: "Cancel button text"),
            style: .cancel
        )
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        return alert
    }
    
}

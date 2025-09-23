import UIKit
import SmileID
import SmileIDUI

class BiometricKYCViewController: UIViewController, SmartSelfieResultDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = SmartSelfieConfig(
            jobType: .biometricKyc,
            jobID: UUID().uuidString,
            userID: "unique-user-id"
        )
        
        let selfieVC = SmartSelfieViewController(
            config: config,
            delegate: self   // ✅ pass self (conforming to SmartSelfieResultDelegate)
        )
        
        present(selfieVC, animated: true, completion: nil)
    }
    
    // MARK: - SmartSelfieResultDelegate
    func didSucceed(
        selfieImage: URL,
        livenessImages: [URL],
        apiResponse: SmartSelfieResponse?
    ) {
        print("✅ Biometric KYC Success")
        print(apiResponse ?? "No response")
        dismiss(animated: true)
    }

    func didError(error: Error) {
        print("❌ Biometric KYC Failed: \(error.localizedDescription)")
        dismiss(animated: true)
    }
}

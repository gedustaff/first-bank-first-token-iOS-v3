import Foundation
import UIKit
import SwiftUI
import SmileID




// MARK: - Delegate wrapper
class SmileIDEnrollmentDelegate: NSObject, SmartSelfieResultDelegate {
    var completionHandler: (([String: Any]?, Error?) -> Void)?

    func didSucceed(
        selfieImage: URL,
        livenessImages: [URL],
        apiResponse: SmartSelfieResponse?
    ) {
        var dict: [String: Any] = [:]
        dict["selfieImage"] = selfieImage.absoluteString
        dict["livenessImages"] = livenessImages.map { $0.absoluteString }
        if let apiResponse = apiResponse {
            // convert response to dictionary
            if let jsonData = try? JSONEncoder().encode(apiResponse),
               let obj = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                dict["apiResponse"] = obj
            }
        }
        completionHandler?(dict, nil)
    }

    func didError(error: Error) {
        completionHandler?(nil, error)
    }
}





@objc class SmileIDBridge: NSObject {
    @MainActor @objc static private var delegate: SmileIDEnrollmentDelegate?

    @MainActor @objc static func presentSelfieEnrollment(
        from controller: UIViewController,
        completion: @escaping (NSString?, NSString?) -> Void
    ) {
        let enrollmentDelegate = SmileIDEnrollmentDelegate()
        enrollmentDelegate.completionHandler = { response, error in
            if let error = error {
                completion(nil, error.localizedDescription as NSString)
            } else if let response = response {
                // Convert to JSON string
                if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    completion(jsonString as NSString, nil)
                } else {
                    completion(nil, "Failed to encode JSON" as NSString)
                }
            } else {
                completion(nil, "Unknown error" as NSString)
            }
        }

        // Launch SmileID screen
        let selfieScreen = SmileID.smartSelfieEnrollmentScreen(delegate: enrollmentDelegate)
        let hostingController = UIHostingController(rootView: selfieScreen)
        controller.present(hostingController, animated: true)

        delegate = enrollmentDelegate
    }
}


//@objc class SmileIDBridge: NSObject, SmartSelfieResultDelegate {
//
//    private var completion: ((NSString?, NSString?) -> Void)?
//
//    // Exposed to Objective-C
//    @MainActor @objc static func presentSelfieEnrollment(
//        from controller: UIViewController,
//        completion: @escaping (NSString?, NSString?) -> Void
//    ) {
//        let bridge = SmileIDBridge()
//        bridge.completion = completion
//
//        // Build the screen with delegate (not closure)
//        let selfieScreen = SmileID.smartSelfieEnrollmentScreen(delegate: bridge)
//
//        let hostingController = UIHostingController(rootView: selfieScreen)
//        controller.present(hostingController, animated: true)
//    }
//
//    // MARK: - SmartSelfieResultDelegate
//    func didSucceed(
//        selfieImage: URL,
//        livenessImages: [URL],
//        apiResponse: SmartSelfieResponse?
//    ) {
//        if let response = apiResponse,
//           let data = try? JSONEncoder().encode(response),
//           let jsonString = String(data: data, encoding: .utf8) {
//            completion?(jsonString as NSString, nil)
//        } else {
//            completion?(nil, "No response" as NSString)
//        }
//    }
//
//    func didError(error: Error) {
//        completion?(nil, error.localizedDescription as NSString)
//    }
//}


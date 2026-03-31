
import Foundation
import UIKit
import SwiftUI
import SmileID
import SmileIDUI

// MARK: - Delegate

final class SmileIDEnrollmentDelegate: NSObject, SmartSelfieResultDelegate {
    
    var completionHandler: (([String: Any]?, Error?) -> Void)?
    
    let jobId: String
    let userId: String
    
    init(jobId: String, userId: String) {
        self.jobId = jobId
        self.userId = userId
        super.init()
    }
    
    func didSucceed(
        selfieImage: URL,
        livenessImages: [URL],
        apiResponse: SmartSelfieResponse?
    ) {
        do {
            var dict: [String: Any] = [
                "jobId": jobId,
                "userId": userId,
                "selfieImage": selfieImage.absoluteString,
                "livenessImages": livenessImages.map { $0.absoluteString }
            ]
            
            if let apiResponse {
                let data = try JSONEncoder().encode(apiResponse)
                dict["apiResponse"] = try JSONSerialization.jsonObject(with: data)
            }
            
            completionHandler?(dict, nil)
        } catch {
            completionHandler?(nil, error)
        }
    }
    

    
    func didError(error: Error) {
        if let smileIDError = error as? SmileIDError {
            switch smileIDError {
            case .api(let code, let message):
                // Handle specific error codes here
                let errorDict: [String: Any] = [
                    "apiResponse": [
                        "code": code,
                        "message": message,
                        "status": "error",
                        "userId": self.userId
                    ]
                ]
                
                if code == "2209" || code == "2215" { // Already enrolled
                    completionHandler?(errorDict, nil) // Don't pass an error
                    return
                }
                
                // For other errors, pass the error normally
                completionHandler?(errorDict, error)
                return
            default:
                break
            }
        }
        completionHandler?(nil, error)  // Fallback for unexpected errors
    }
    
}




// MARK: - Initializer

@objc final class SmileIDInitializer: NSObject {

    @MainActor
    @objc static func initializeSmileID() {
        SmileID.initialize()
    }
}


@objc class SmileIDBridge: NSObject {

    @MainActor private static var activeDelegate: SmileIDEnrollmentDelegate?
    @MainActor private static weak var hostingController: UIViewController?

    @MainActor
    @objc(presentSelfieEnrollmentFrom:jobId:userId:allowReEnroll:completion:)
    static func presentSelfieEnrollment(
        from controller: UIViewController,
        jobId: String,
        userId: String,
        allowReEnroll: Bool,
        completion: @escaping (NSString?, NSString?) -> Void
    ) {

        let delegate = SmileIDEnrollmentDelegate(jobId: jobId, userId: userId)
        Self.activeDelegate = delegate

        delegate.completionHandler = { response, error in
            DispatchQueue.main.async {
                Self.hostingController?.dismiss(animated: true)
                Self.hostingController = nil
                Self.activeDelegate = nil

                if let error {
                    completion(nil, error.localizedDescription as NSString)
                    return
                }

                guard let response,
                      let data = try? JSONSerialization.data(withJSONObject: response),
                      let json = String(data: data, encoding: .utf8)
                else {
                    completion(nil, "Invalid SmileID response" as NSString)
                    return
                }

                completion(json as NSString, nil)
            }
        }

        let view: AnyView

        if allowReEnroll {
            print("Launching RE-ENROLLMENT flow")

            view = AnyView(
                SmileID.smartSelfieEnrollmentScreen(
                    userId: userId,
                    jobId: jobId,
                    allowNewEnroll: true,
                    delegate: delegate
                )
            )

        } else {
            print(" Launching NEW ENROLLMENT flow")

            view = AnyView(
                SmileID.smartSelfieEnrollmentScreen(
                    userId: userId,
                    jobId: jobId,
                    allowNewEnroll: false,
                    delegate: delegate
                )
            )
        }

        let hosting = UIHostingController(rootView: view)
        hosting.modalPresentationStyle = .fullScreen
        Self.hostingController = hosting
        controller.present(hosting, animated: true)

// MARK: - Bridge
//
//@objc class SmileIDBridge: NSObject {
//
//    @MainActor private static var activeDelegate: SmileIDEnrollmentDelegate?
//    @MainActor private static weak var hostingController: UIViewController?
//
//    // MARK: - Objective-C exposed method WITH allowReEnroll
//    @MainActor
//    @objc(presentSelfieEnrollmentFrom:jobId:userId:allowReEnroll:completion:)
//    static func presentSelfieEnrollment(
//        from controller: UIViewController,
//        jobId: String,
//        userId: String,
//        allowReEnroll: Bool,
//        completion: @escaping (NSString?, NSString?) -> Void
//    ) {
//        let enrollmentDelegate = SmileIDEnrollmentDelegate(jobId: jobId, userId: userId)
//        Self.activeDelegate = enrollmentDelegate
//
//        enrollmentDelegate.completionHandler = { response, error in
//            Task { @MainActor in
//                Self.hostingController?.dismiss(animated: true)
//
//                Self.activeDelegate = nil
//                Self.hostingController = nil
//
//                if let error {
//                    completion(nil, error.localizedDescription as NSString)
//                    return
//                }
//
//                guard let response,
//                      let data = try? JSONSerialization.data(withJSONObject: response),
//                      let json = String(data: data, encoding: .utf8)
//                else {
//                    completion(nil, "Invalid SmileID response" as NSString)
//                    return
//                }
//
//                completion(json as NSString, nil)
//            }
//        }
//        let selfieView: AnyView
//
//        if allowReEnroll {
//            print(" Launching RE-ENROLLMENT flow")
//
//            selfieView = AnyView(
//                SmileID.smartSelfieEnrollmentScreen(
//                    userId: userId,
//                    jobId: jobId,
//                    allowNewEnroll: true,
//                    delegate: enrollmentDelegate
//                )
//            )
//        } else {
//            print(" Launching NEW ENROLLMENT flow")
//
//            selfieView = AnyView(
//                SmileID.smartSelfieEnrollmentScreen(
//                    userId: userId,
//                    jobId: jobId,
//                    allowNewEnroll: false,
//                    delegate: enrollmentDelegate
//                )
//            )
//        }
//
//        let hosting = UIHostingController(rootView: selfieView)
//        hosting.modalPresentationStyle = .fullScreen
//        controller.present(hosting, animated: true)


     
//        let selfieScreen = SmileID.smartSelfieEnrollmentScreen(
//            userId: userId,
//            jobId: jobId,
//            allowNewEnroll: allowReEnroll,
//            delegate: enrollmentDelegate
//        )

    }
}


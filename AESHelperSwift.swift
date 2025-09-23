import Foundation
import CryptoKit

@objc class AESHelperSwift: NSObject {
    @objc static func decrypt(base64Cipher: String, hexKey: String) -> String? {
        guard let allData = Data(base64Encoded: base64Cipher) else {
            print("Invalid base64")
            return nil
        }

        // Extract IV (12 bytes), Ciphertext, and Tag (16 bytes)
        guard allData.count > 12 + 16 else {
            print("Data too short")
            return nil
        }

        let iv = allData.prefix(12)
        let cipherText = allData.dropFirst(12).dropLast(16)
        let tag = allData.suffix(16)

        // Convert hex key to Data
        var keyData = Data()
        var hex = hexKey
        while hex.count > 0 {
            let c = String(hex.prefix(2))
            hex = String(hex.dropFirst(2))
            var ch: UInt64 = 0
            Scanner(string: c).scanHexInt64(&ch)
            var byte = UInt8(ch)
            keyData.append(&byte, count: 1)
        }

        do {
            let key = SymmetricKey(data: keyData)
            let nonce = try AES.GCM.Nonce(data: iv)
            let sealedBox = try AES.GCM.SealedBox(nonce: nonce,
                                                  ciphertext: cipherText,
                                                  tag: tag)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            print("Decryption failed: \(error)")
            return nil
        }
    }
}


import Foundation

final class AppStorageManager {

    // MARK: - Keys
    private static let isUserRegisteredKey = "isUserRegistered"
    private static let userEmailKey = "userEmail"

    // MARK: - Registration Status
    static var isUserRegistered: Bool {
        get {
            UserDefaults.standard.bool(forKey: isUserRegisteredKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isUserRegisteredKey)
        }
    }

    // MARK: - Email Storage
    static var userEmail: String? {
        get {
            UserDefaults.standard.string(forKey: userEmailKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userEmailKey)
        }
    }

    // MARK: - Clear Session
    static func clearSession() {
        UserDefaults.standard.removeObject(forKey: isUserRegisteredKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
    }
}

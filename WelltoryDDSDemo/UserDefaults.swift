import Foundation

extension UserDefaults {
    
    enum Keys: String {
        case firstMeasurement = "firstMeasurement"
    }
    
    var isFirstMeasurement: Bool {
        get {
            return !self.bool(forKey: Keys.firstMeasurement.rawValue)
        } set {
            self.set(!newValue, forKey: Keys.firstMeasurement.rawValue)
        }
    }
}

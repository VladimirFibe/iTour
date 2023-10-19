import Foundation
import SwiftData

@Model
final class Sight {
    var name: String
    init(name: String = "") {
        self.name = name
    }
}

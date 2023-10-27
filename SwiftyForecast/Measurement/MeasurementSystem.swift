enum MeasurementSystem: Int {
    case imperial
    case metric

    var locale: String {
        switch self {
        case .imperial:
            return "en_US"

        case .metric:
            return "pl_PL"
        }
    }
}

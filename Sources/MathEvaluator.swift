import Foundation

struct MathEvaluator {
    static func evaluate(_ expression: String) -> Double? {
        let cleanExpression = expression.replacingOccurrences(of: " ", with: "")
        guard !cleanExpression.isEmpty else { return nil }

        let nsExpression = NSExpression(format: cleanExpression)
        if let result = nsExpression.expressionValue(with: nil, context: nil) as? Double {
            return result
        } else if let result = nsExpression.expressionValue(with: nil, context: nil) as? Int {
            return Double(result)
        }

        return nil
    }
}

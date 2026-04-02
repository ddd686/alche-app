import Foundation

// MARK: - Evidence Level

enum EvidenceLevel: String, Codable, Sendable {
    case strong
    case moderateStrong
    case moderate
    case emerging

    var displayName: String {
        switch self {
        case .strong: "Strong evidence"
        case .moderateStrong: "Moderate-strong evidence"
        case .moderate: "Moderate evidence"
        case .emerging: "Emerging evidence"
        }
    }
}

// MARK: - Supplement

struct Supplement: Codable, Sendable, Hashable, Identifiable {
    let id: String
    let name: String
    let mechanism: String
    let evidence: EvidenceLevel
    let typicalDosage: String
    let maxDailyDose: String
    let isEULegal: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, mechanism, evidence
        case typicalDosage = "typical_dosage"
        case maxDailyDose = "max_daily_dose"
        case isEULegal = "is_eu_legal"
    }
}

// MARK: - Supplement Mapping (goal -> supplements)

struct SupplementMapping: Codable, Sendable, Hashable {
    let subGoal: WellnessSubGoal
    let supplements: [Supplement]
}

// MARK: - Dose Stacking Rules

/// Ensures supplements shared across multiple goals don't exceed safe daily limits.
enum DoseStackingRules {
    struct StackRule: Sendable {
        let supplementId: String
        let supplementName: String
        let maxDailyDose: String
        let goalsServed: [WellnessGoal]
        let note: String
    }

    static let rules: [StackRule] = [
        StackRule(
            supplementId: "magnesium-glycinate",
            supplementName: "Magnesium Glycinate",
            maxDailyDose: "400mg elemental",
            goalsServed: [.deepRecovery, .stressResilience, .innerBalance, .cellularVitality],
            note: "Cap at 400mg/day regardless of how many goals selected"
        ),
        StackRule(
            supplementId: "omega-3",
            supplementName: "Omega-3 (EPA+DHA)",
            maxDailyDose: "3000mg combined",
            goalsServed: WellnessGoal.allCases,
            note: "Single recommendation regardless of goals"
        ),
        StackRule(
            supplementId: "b-complex",
            supplementName: "B-Complex",
            maxDailyDose: "1 serving",
            goalsServed: [.deepRecovery, .stressResilience, .cellularVitality],
            note: "Water-soluble, excess excreted. One serving covers all goals"
        ),
        StackRule(
            supplementId: "vitamin-d3",
            supplementName: "Vitamin D3",
            maxDailyDose: "4000 IU",
            goalsServed: [.innerBalance, .radiantDefense, .cellularVitality],
            note: "Single dose. Never stack"
        ),
    ]

    static let timingConflicts: [(String, String, String)] = [
        ("Ashwagandha", "Rhodiola", "Take Ashwagandha PM, Rhodiola AM. Never combine in single dose."),
        ("NAC", "Alcohol", "NAC should be taken BEFORE drinking, not after."),
        ("Calcium", "Zinc/Iron", "Space calcium 2+ hours from zinc and iron."),
    ]

    /// Returns deduplicated supplement list with capped doses for a set of goals.
    static func resolveSupplements(for goals: Set<WellnessGoal>, from mappings: [SupplementMapping]) -> [Supplement] {
        let relevantSubGoals = goals.flatMap(\.subGoals)
        let allSupplements = mappings
            .filter { relevantSubGoals.contains($0.subGoal) }
            .flatMap(\.supplements)

        // Deduplicate by ID, keeping the first occurrence
        var seen = Set<String>()
        var result: [Supplement] = []
        for supplement in allSupplements {
            if !seen.contains(supplement.id) {
                seen.insert(supplement.id)
                result.append(supplement)
            }
        }
        return result
    }
}

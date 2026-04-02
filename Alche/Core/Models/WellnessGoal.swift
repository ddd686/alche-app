import Foundation

// MARK: - Wellness Goal (replaces old ProtocolGoal for goal system)

enum WellnessGoal: String, Codable, Sendable, CaseIterable, Hashable, Identifiable {
    case deepRecovery
    case stressResilience
    case innerBalance
    case radiantDefense
    case cellularVitality

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .deepRecovery: "Deep Recovery"
        case .stressResilience: "Stress Resilience"
        case .innerBalance: "Inner Balance"
        case .radiantDefense: "Radiant Defense"
        case .cellularVitality: "Cellular Vitality"
        }
    }

    var codeTag: String {
        switch self {
        case .deepRecovery: "[RESTORE_PATHWAY_ACTIVE]"
        case .stressResilience: "[CORTISOL_DAMPENING_SEQ]"
        case .innerBalance: "[HOMEOSTASIS_CALIBRATION]"
        case .radiantDefense: "[DERMAL_LUMINOSITY_MATRIX]"
        case .cellularVitality: "[CYTOKINE_MODULATION_ACTIVE]"
        }
    }

    var index: String {
        switch self {
        case .deepRecovery: "01"
        case .stressResilience: "02"
        case .innerBalance: "03"
        case .radiantDefense: "04"
        case .cellularVitality: "05"
        }
    }

    var userFeeling: String {
        switch self {
        case .deepRecovery: "I bounce back fast"
        case .stressResilience: "I handle pressure well"
        case .innerBalance: "My body feels regulated"
        case .radiantDefense: "I look as good as I feel"
        case .cellularVitality: "I have deep, sustained energy"
        }
    }

    var scienceTarget: String {
        switch self {
        case .deepRecovery: "Liver support, sleep optimization, oxidative damage repair"
        case .stressResilience: "HPA axis regulation, cortisol modulation, nervous system balance"
        case .innerBalance: "Hormonal support, gut-brain axis, metabolic homeostasis"
        case .radiantDefense: "Antioxidant protection, skin barrier support, photoaging defense"
        case .cellularVitality: "Anti-inflammation, mitochondrial function, NAD+ support"
        }
    }

    var subGoals: [WellnessSubGoal] {
        switch self {
        case .deepRecovery: [.sleepOptimization, .liverReset, .physicalRecovery]
        case .stressResilience: [.cortisolBalance, .mentalClarity, .nervousSystemSupport]
        case .innerBalance: [.hormonalCycleSupport, .gutHarmony, .metabolicSteadiness]
        case .radiantDefense: [.skinProtection, .hairNailStrength, .antioxidantShield]
        case .cellularVitality: [.antiInflammation, .mitochondrialEnergy, .longevityFoundations]
        }
    }

    /// Maps to legacy ProtocolGoal for backward compatibility with existing protocols
    var legacyGoalTag: ProtocolGoal? {
        switch self {
        case .deepRecovery: .recovery
        case .stressResilience: .calm
        case .innerBalance: .gut
        case .radiantDefense: .glow
        case .cellularVitality: .energy
        }
    }
}

// MARK: - Sub-Goals

enum WellnessSubGoal: String, Codable, Sendable, Hashable, Identifiable {
    // Deep Recovery
    case sleepOptimization
    case liverReset
    case physicalRecovery
    // Stress Resilience
    case cortisolBalance
    case mentalClarity
    case nervousSystemSupport
    // Inner Balance
    case hormonalCycleSupport
    case gutHarmony
    case metabolicSteadiness
    // Radiant Defense
    case skinProtection
    case hairNailStrength
    case antioxidantShield
    // Cellular Vitality
    case antiInflammation
    case mitochondrialEnergy
    case longevityFoundations

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .sleepOptimization: "Sleep Optimization"
        case .liverReset: "Liver & Metabolic Reset"
        case .physicalRecovery: "Physical Recovery"
        case .cortisolBalance: "Cortisol Balance"
        case .mentalClarity: "Mental Clarity Under Pressure"
        case .nervousSystemSupport: "Nervous System Support"
        case .hormonalCycleSupport: "Hormonal Cycle Support"
        case .gutHarmony: "Gut Harmony"
        case .metabolicSteadiness: "Metabolic Steadiness"
        case .skinProtection: "Skin Protection & Hydration"
        case .hairNailStrength: "Hair & Nail Strength"
        case .antioxidantShield: "Antioxidant Shield"
        case .antiInflammation: "Anti-Inflammation"
        case .mitochondrialEnergy: "Mitochondrial Energy"
        case .longevityFoundations: "Longevity Foundations"
        }
    }

    var userFraming: String {
        switch self {
        case .sleepOptimization: "I want to fall asleep faster and wake up restored"
        case .liverReset: "I want to support my body after social nights or travel"
        case .physicalRecovery: "I want my muscles and joints to recover faster"
        case .cortisolBalance: "I want to lower my baseline stress and feel calmer"
        case .mentalClarity: "I want to think clearly when things get intense"
        case .nervousSystemSupport: "I want to stop feeling wired but tired"
        case .hormonalCycleSupport: "I want less PMS, more predictable cycles"
        case .gutHarmony: "I want better digestion and less bloating"
        case .metabolicSteadiness: "I want stable energy without crashes"
        case .skinProtection: "I want my skin to look healthy and age slower"
        case .hairNailStrength: "I want stronger hair and nails"
        case .antioxidantShield: "I want to protect my body from environmental damage"
        case .antiInflammation: "I want to reduce chronic low-grade inflammation"
        case .mitochondrialEnergy: "I want deep, sustained energy — not stimulant highs"
        case .longevityFoundations: "I want to invest in aging well at the cellular level"
        }
    }
}

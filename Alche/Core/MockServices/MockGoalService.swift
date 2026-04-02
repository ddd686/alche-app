import Foundation

final class MockGoalService: GoalServiceProtocol, @unchecked Sendable {
    private let userGoalsKey = "alche_user_goals"

    func allGoals() async throws -> [WellnessGoal] {
        try await Task.sleep(for: .milliseconds(300))
        return WellnessGoal.allCases
    }

    func subGoals(for goal: WellnessGoal) async throws -> [WellnessSubGoal] {
        try await Task.sleep(for: .milliseconds(200))
        return goal.subGoals
    }

    func supplementMappings(for goals: Set<WellnessGoal>) async throws -> [SupplementMapping] {
        try await Task.sleep(for: .milliseconds(500))
        return goals.flatMap { goal in
            goal.subGoals.map { subGoal in
                SupplementMapping(
                    subGoal: subGoal,
                    supplements: Self.supplementsForSubGoal(subGoal)
                )
            }
        }
    }

    func resolvedSupplements(for goals: Set<WellnessGoal>) async throws -> [Supplement] {
        let mappings = try await supplementMappings(for: goals)
        return DoseStackingRules.resolveSupplements(for: goals, from: mappings)
    }

    func saveUserGoals(userId: UUID, goals: Set<WellnessGoal>) async throws {
        try await Task.sleep(for: .milliseconds(300))
        let rawValues = goals.map(\.rawValue)
        UserDefaults.standard.set(rawValues, forKey: "\(userGoalsKey)_\(userId.uuidString)")
    }

    func userGoals(userId: UUID) async throws -> Set<WellnessGoal> {
        try await Task.sleep(for: .milliseconds(200))
        let rawValues = UserDefaults.standard.stringArray(forKey: "\(userGoalsKey)_\(userId.uuidString)") ?? []
        return Set(rawValues.compactMap { WellnessGoal(rawValue: $0) })
    }

    // MARK: - Sample Supplement Data

    private static func supplementsForSubGoal(_ subGoal: WellnessSubGoal) -> [Supplement] {
        switch subGoal {
        case .sleepOptimization:
            return [
                Supplement(id: "magnesium-glycinate", name: "Magnesium Glycinate", mechanism: "Regulates GABA receptors, supports melatonin production", evidence: .strong, typicalDosage: "200-400mg elemental Mg", maxDailyDose: "400mg", isEULegal: true),
                Supplement(id: "glycine", name: "Glycine", mechanism: "Lowers core body temperature, improves subjective sleep quality", evidence: .moderate, typicalDosage: "3g before bed", maxDailyDose: "3g", isEULegal: true),
                Supplement(id: "l-theanine", name: "L-Theanine", mechanism: "Promotes alpha brain wave activity without sedation", evidence: .moderate, typicalDosage: "100-200mg before bed", maxDailyDose: "400mg", isEULegal: true),
            ]
        case .liverReset:
            return [
                Supplement(id: "nac", name: "NAC", mechanism: "Precursor to glutathione, supports Phase II liver detoxification", evidence: .strong, typicalDosage: "600-1200mg", maxDailyDose: "1200mg", isEULegal: true),
                Supplement(id: "milk-thistle", name: "Milk Thistle (Silymarin)", mechanism: "Stabilizes hepatocyte membranes, stimulates liver cell regeneration", evidence: .moderate, typicalDosage: "200-400mg", maxDailyDose: "400mg", isEULegal: true),
                Supplement(id: "b-complex", name: "B-Complex", mechanism: "Replenishes B vitamins depleted by alcohol and stress", evidence: .strong, typicalDosage: "1 serving (100% RDA+)", maxDailyDose: "1 serving", isEULegal: true),
            ]
        case .physicalRecovery:
            return [
                Supplement(id: "omega-3", name: "Omega-3 (EPA+DHA)", mechanism: "EPA-derived resolvins resolve exercise-induced inflammation", evidence: .strong, typicalDosage: "1000-2000mg combined", maxDailyDose: "3000mg", isEULegal: true),
                Supplement(id: "creatine", name: "Creatine Monohydrate", mechanism: "Maintains ATP levels, supports recovery across all age groups", evidence: .strong, typicalDosage: "3-5g daily", maxDailyDose: "5g", isEULegal: true),
                Supplement(id: "tart-cherry", name: "Tart Cherry Extract", mechanism: "Anthocyanins reduce muscle damage markers and DOMS", evidence: .moderate, typicalDosage: "480mg anthocyanins", maxDailyDose: "480mg", isEULegal: true),
            ]
        case .cortisolBalance:
            return [
                Supplement(id: "ashwagandha", name: "Ashwagandha (KSM-66)", mechanism: "Modulates HPA axis, reduces cortisol by 20-30% in 8-12 weeks", evidence: .strong, typicalDosage: "300-600mg/day", maxDailyDose: "600mg", isEULegal: true),
                Supplement(id: "magnesium-glycinate", name: "Magnesium Glycinate", mechanism: "Helps body clear cortisol via 11-beta-HSD2 enzyme", evidence: .strong, typicalDosage: "250-400mg elemental Mg", maxDailyDose: "400mg", isEULegal: true),
                Supplement(id: "phosphatidylserine", name: "Phosphatidylserine", mechanism: "Blunts cortisol response to acute stressors", evidence: .moderate, typicalDosage: "100-300mg/day", maxDailyDose: "300mg", isEULegal: true),
            ]
        case .mentalClarity:
            return [
                Supplement(id: "l-theanine", name: "L-Theanine", mechanism: "Promotes relaxed focus, synergistic with caffeine", evidence: .moderateStrong, typicalDosage: "100-200mg", maxDailyDose: "400mg", isEULegal: true),
                Supplement(id: "rhodiola", name: "Rhodiola Rosea", mechanism: "Reduces mental fatigue under stress, modulates serotonin and dopamine", evidence: .moderate, typicalDosage: "200-400mg", maxDailyDose: "400mg", isEULegal: true),
                Supplement(id: "b-complex", name: "B-Complex", mechanism: "B5 supports adrenal function, B6 supports GABA synthesis", evidence: .strong, typicalDosage: "1 serving (100-200% RDA)", maxDailyDose: "1 serving", isEULegal: true),
            ]
        case .nervousSystemSupport:
            return [
                Supplement(id: "magnesium-glycinate", name: "Magnesium Glycinate", mechanism: "Essential for nerve signal transmission, regulates NMDA receptors", evidence: .strong, typicalDosage: "250-400mg elemental Mg", maxDailyDose: "400mg", isEULegal: true),
                Supplement(id: "omega-3", name: "Omega-3 (EPA+DHA)", mechanism: "DHA is structural component of brain cell membranes", evidence: .strong, typicalDosage: "1000-2000mg combined", maxDailyDose: "3000mg", isEULegal: true),
                Supplement(id: "saffron", name: "Saffron Extract", mechanism: "Modulates serotonin reuptake, reduces cortisol", evidence: .moderate, typicalDosage: "30mg/day", maxDailyDose: "30mg", isEULegal: true),
            ]
        case .hormonalCycleSupport:
            return [
                Supplement(id: "chasteberry", name: "Chasteberry (Vitex)", mechanism: "Restores estrogen-progesterone balance, reduces prolactin", evidence: .strong, typicalDosage: "20-40mg/day", maxDailyDose: "40mg", isEULegal: true),
                Supplement(id: "calcium-d", name: "Calcium + Vitamin D", mechanism: "Reduces total PMS symptom scores by ~50%", evidence: .strong, typicalDosage: "Ca 1000mg + D 1000-2000 IU", maxDailyDose: "Ca 1200mg + D 4000 IU", isEULegal: true),
                Supplement(id: "magnesium-glycinate", name: "Magnesium Glycinate", mechanism: "Reduces PMS-related bloating and fluid retention", evidence: .moderate, typicalDosage: "250-360mg/day", maxDailyDose: "400mg", isEULegal: true),
            ]
        case .gutHarmony:
            return [
                Supplement(id: "probiotics", name: "Probiotics (Multi-Strain)", mechanism: "Restore diverse gut microbiome, support serotonin production", evidence: .strong, typicalDosage: "10-50 billion CFU", maxDailyDose: "50B CFU", isEULegal: true),
                Supplement(id: "l-glutamine", name: "L-Glutamine", mechanism: "Primary fuel for intestinal cells, reduces permeability", evidence: .moderate, typicalDosage: "5-10g/day", maxDailyDose: "10g", isEULegal: true),
                Supplement(id: "prebiotic-fiber", name: "Prebiotic Fiber (Inulin/FOS)", mechanism: "Feeds beneficial gut bacteria, increases SCFA production", evidence: .strong, typicalDosage: "5-10g/day", maxDailyDose: "10g", isEULegal: true),
            ]
        case .metabolicSteadiness:
            return [
                Supplement(id: "berberine", name: "Berberine", mechanism: "Activates AMPK, improves insulin sensitivity", evidence: .strong, typicalDosage: "500mg 2-3x/day", maxDailyDose: "1500mg", isEULegal: true),
                Supplement(id: "chromium", name: "Chromium Picolinate", mechanism: "Enhances insulin receptor sensitivity, reduces cravings", evidence: .moderate, typicalDosage: "200-400mcg/day", maxDailyDose: "400mcg", isEULegal: true),
                Supplement(id: "magnesium-glycinate", name: "Magnesium Glycinate", mechanism: "Supports insulin signaling and 300+ metabolic enzymes", evidence: .strong, typicalDosage: "250-400mg/day", maxDailyDose: "400mg", isEULegal: true),
            ]
        case .skinProtection:
            return [
                Supplement(id: "vitamin-c", name: "Vitamin C", mechanism: "Essential cofactor for collagen synthesis, UV protection", evidence: .strong, typicalDosage: "500-1000mg/day", maxDailyDose: "1000mg", isEULegal: true),
                Supplement(id: "astaxanthin", name: "Astaxanthin", mechanism: "Carotenoid antioxidant protecting skin from UV internally", evidence: .moderateStrong, typicalDosage: "4-12mg/day", maxDailyDose: "12mg", isEULegal: true),
                Supplement(id: "hyaluronic-acid", name: "Hyaluronic Acid (oral)", mechanism: "Supports skin hydration from within", evidence: .moderate, typicalDosage: "120-240mg/day", maxDailyDose: "240mg", isEULegal: true),
            ]
        case .hairNailStrength:
            return [
                Supplement(id: "zinc", name: "Zinc", mechanism: "Essential for hair tissue growth and oil gland function", evidence: .moderate, typicalDosage: "15-25mg/day", maxDailyDose: "25mg", isEULegal: true),
                Supplement(id: "vitamin-c-iron", name: "Vitamin C + Iron", mechanism: "Vitamin C improves non-heme iron absorption for hair health", evidence: .strong, typicalDosage: "C: 500mg + Iron: 14-18mg", maxDailyDose: "C: 1000mg + Iron: 18mg", isEULegal: true),
                Supplement(id: "silica", name: "Silica (Bamboo Extract)", mechanism: "Supports collagen and keratin cross-linking", evidence: .emerging, typicalDosage: "10-20mg/day", maxDailyDose: "20mg", isEULegal: true),
            ]
        case .antioxidantShield:
            return [
                Supplement(id: "vitamin-c", name: "Vitamin C", mechanism: "Water-soluble antioxidant, regenerates vitamin E", evidence: .strong, typicalDosage: "500-1000mg/day", maxDailyDose: "1000mg", isEULegal: true),
                Supplement(id: "vitamin-e", name: "Vitamin E (Mixed Tocopherols)", mechanism: "Fat-soluble antioxidant protecting cell membranes", evidence: .strong, typicalDosage: "15-100mg/day", maxDailyDose: "100mg", isEULegal: true),
                Supplement(id: "selenium", name: "Selenium", mechanism: "Essential cofactor for glutathione peroxidase", evidence: .strong, typicalDosage: "55-100mcg/day", maxDailyDose: "200mcg", isEULegal: true),
            ]
        case .antiInflammation:
            return [
                Supplement(id: "omega-3", name: "Omega-3 (EPA+DHA)", mechanism: "EPA-derived resolvins actively resolve inflammation", evidence: .strong, typicalDosage: "1000-3000mg combined", maxDailyDose: "3000mg", isEULegal: true),
                Supplement(id: "curcumin", name: "Curcumin + Piperine", mechanism: "Blocks NF-kB inflammatory pathway, comparable to ibuprofen in OA", evidence: .moderateStrong, typicalDosage: "500-1500mg + 5-10mg piperine", maxDailyDose: "1500mg", isEULegal: true),
                Supplement(id: "vitamin-d3", name: "Vitamin D3", mechanism: "Modulates immune response, reduces pro-inflammatory cytokines", evidence: .strong, typicalDosage: "1000-4000 IU/day", maxDailyDose: "4000 IU", isEULegal: true),
            ]
        case .mitochondrialEnergy:
            return [
                Supplement(id: "coq10", name: "CoQ10 (Ubiquinol)", mechanism: "Essential electron carrier in mitochondrial respiratory chain", evidence: .strong, typicalDosage: "100-300mg/day", maxDailyDose: "300mg", isEULegal: true),
                Supplement(id: "nr", name: "NR (Nicotinamide Riboside)", mechanism: "NAD+ precursor, supports sirtuin activation and DNA repair", evidence: .moderate, typicalDosage: "300-500mg/day", maxDailyDose: "500mg", isEULegal: true),
                Supplement(id: "alpha-lipoic-acid", name: "Alpha-Lipoic Acid", mechanism: "Universal antioxidant, supports mitochondrial enzymes", evidence: .moderate, typicalDosage: "300-600mg/day", maxDailyDose: "600mg", isEULegal: true),
            ]
        case .longevityFoundations:
            return [
                Supplement(id: "omega-3", name: "Omega-3 (EPA+DHA)", mechanism: "Beneficial effect on telomere length, reduces cardiovascular mortality", evidence: .strong, typicalDosage: "1000-2000mg combined", maxDailyDose: "3000mg", isEULegal: true),
                Supplement(id: "vitamin-d3", name: "Vitamin D3", mechanism: "Modulates 1,000+ genes, 16% reduction in cancer mortality", evidence: .strong, typicalDosage: "1000-4000 IU/day", maxDailyDose: "4000 IU", isEULegal: true),
                Supplement(id: "spermidine", name: "Spermidine", mechanism: "Induces autophagy (cellular self-cleaning)", evidence: .emerging, typicalDosage: "1-6mg/day", maxDailyDose: "6mg", isEULegal: true),
            ]
        }
    }
}

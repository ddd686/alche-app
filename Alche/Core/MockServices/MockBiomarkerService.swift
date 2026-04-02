import Foundation

/// Mock implementation of BiomarkerServiceProtocol.
/// Generates biologically plausible biomarker profiles for a health-conscious
/// 30-something in Berlin. Vitamin D is low (it's Berlin). Inflammation is
/// normal-low. Biological age = real age minus 2-4 years.
final class MockBiomarkerService: BiomarkerServiceProtocol {

    private let generator = MockDataGenerator.shared
    private let userDefaultsKey = "alche.mock.biomarkerProfile"

    func currentProfile(userId: UUID) async throws -> BiomarkerProfile? {
        loadProfile(userId: userId)
    }

    func profileHistory(userId: UUID) async throws -> [BiomarkerProfile] {
        if let profile = loadProfile(userId: userId) {
            return [profile]
        }
        return []
    }

    func biomarkers(profileId: UUID) async throws -> [Biomarker] {
        generateAllBiomarkers(profileId: profileId)
    }

    func biomarkers(profileId: UUID, category: BiomarkerCategory) async throws -> [Biomarker] {
        generateAllBiomarkers(profileId: profileId).filter { $0.category == category }
    }

    func generateInitialProfile(userId: UUID, chronologicalAge: Int) async throws -> BiomarkerProfile {
        // Simulate processing
        try await Task.sleep(for: .seconds(1.5))

        let ageReduction = generator.seededDouble(userId: userId, offset: 100, min: 2.0, max: 4.0)
        let biologicalAge = Double(chronologicalAge) - ageReduction

        let profile = BiomarkerProfile(
            id: UUID(),
            userId: userId,
            biologicalAge: biologicalAge,
            chronologicalAge: chronologicalAge,
            overallScore: generator.seededRandom(userId: userId, offset: 200, min: 70, max: 82),
            isMock: true,
            source: .mock,
            recordedAt: Date()
        )

        saveProfile(profile, userId: userId)
        return profile
    }

    // MARK: - Mock Biomarker Data

    private func generateAllBiomarkers(profileId: UUID) -> [Biomarker] {
        let pid = profileId
        return [
            // Inflammation
            Biomarker(
                id: UUID(), profileId: pid, category: .inflammation,
                markerName: "hsCRP", value: 0.8, unit: "mg/L",
                referenceMin: 0, referenceMax: 3.0,
                status: .optimal, displayName: "C-Reactive Protein",
                whatItMeans: "Your inflammation markers look well within the healthy range. This suggests your body is managing stress and recovery well.",
                recommendation: "Keep up your current anti-inflammatory habits. The Recovery smoothie with its turmeric base supports this."
            ),
            Biomarker(
                id: UUID(), profileId: pid, category: .inflammation,
                markerName: "IL-6", value: 2.1, unit: "pg/mL",
                referenceMin: 0, referenceMax: 7.0,
                status: .optimal, displayName: "Interleukin-6",
                whatItMeans: "Your IL-6 levels look healthy, suggesting good inflammatory balance.",
                recommendation: "Regular movement and adequate sleep support healthy IL-6 levels."
            ),

            // Metabolic
            Biomarker(
                id: UUID(), profileId: pid, category: .metabolic,
                markerName: "HbA1c", value: 5.1, unit: "%",
                referenceMin: 4.0, referenceMax: 5.7,
                status: .normal, displayName: "HbA1c",
                whatItMeans: "Your long-term blood sugar balance looks normal. This reflects how your body has been handling glucose over the past 2-3 months.",
                recommendation: "A balanced diet with whole foods and regular movement supports healthy blood sugar."
            ),
            Biomarker(
                id: UUID(), profileId: pid, category: .metabolic,
                markerName: "fasting_glucose", value: 88, unit: "mg/dL",
                referenceMin: 70, referenceMax: 100,
                status: .normal, displayName: "Fasting Glucose",
                whatItMeans: "Your fasting glucose looks healthy and well-regulated.",
                recommendation: "Continue balanced meals. Our Gut smoothie supports metabolic wellness."
            ),

            // Hormones
            Biomarker(
                id: UUID(), profileId: pid, category: .hormones,
                markerName: "cortisol_am", value: 14.5, unit: "ug/dL",
                referenceMin: 6.2, referenceMax: 19.4,
                status: .normal, displayName: "Morning Cortisol",
                whatItMeans: "Your morning cortisol looks within a healthy range, suggesting a normal stress response pattern.",
                recommendation: "Morning light exposure and the Calm smoothie with adaptogens support healthy cortisol rhythms."
            ),
            Biomarker(
                id: UUID(), profileId: pid, category: .hormones,
                markerName: "TSH", value: 2.1, unit: "mIU/L",
                referenceMin: 0.4, referenceMax: 4.0,
                status: .normal, displayName: "Thyroid (TSH)",
                whatItMeans: "Your thyroid function marker looks balanced.",
                recommendation: "Adequate selenium and iodine from a varied diet support thyroid wellness."
            ),

            // Nutrients -- Vitamin D intentionally low (Berlin winter pattern)
            Biomarker(
                id: UUID(), profileId: pid, category: .nutrients,
                markerName: "25-hydroxyvitamin D", value: 22.0, unit: "ng/mL",
                referenceMin: 30.0, referenceMax: 80.0,
                status: .attention, displayName: "Vitamin D",
                whatItMeans: "Your vitamin D looks a little low, which is very common in Berlin, especially during the darker months. It supports bone health, immune function, and mood.",
                recommendation: "Consider a daily vitamin D3 supplement (2000-4000 IU) taken with a meal that contains some fat. Our Energy blend includes vitamin D."
            ),
            Biomarker(
                id: UUID(), profileId: pid, category: .nutrients,
                markerName: "ferritin", value: 45, unit: "ng/mL",
                referenceMin: 20, referenceMax: 200,
                status: .normal, displayName: "Iron (Ferritin)",
                whatItMeans: "Your iron stores look adequate. Ferritin reflects how much iron your body has in reserve.",
                recommendation: "A balanced diet with leafy greens and occasional red meat or legumes supports healthy iron levels."
            ),
            Biomarker(
                id: UUID(), profileId: pid, category: .nutrients,
                markerName: "B12", value: 380, unit: "pg/mL",
                referenceMin: 200, referenceMax: 900,
                status: .normal, displayName: "Vitamin B12",
                whatItMeans: "Your B12 levels look solid. B12 supports energy, nerve function, and red blood cell production.",
                recommendation: "If you follow a plant-based diet, consider B12 supplementation."
            ),
            Biomarker(
                id: UUID(), profileId: pid, category: .nutrients,
                markerName: "magnesium", value: 1.9, unit: "mg/dL",
                referenceMin: 1.7, referenceMax: 2.2,
                status: .normal, displayName: "Magnesium",
                whatItMeans: "Your magnesium looks within a healthy range. It supports muscle recovery, sleep quality, and nerve function.",
                recommendation: "An evening magnesium glycinate supplement supports deeper sleep. Part of our Sleep Protocol."
            ),

            // Cardiovascular
            Biomarker(
                id: UUID(), profileId: pid, category: .cardiovascular,
                markerName: "total_cholesterol", value: 185, unit: "mg/dL",
                referenceMin: 125, referenceMax: 200,
                status: .normal, displayName: "Total Cholesterol",
                whatItMeans: "Your total cholesterol looks well within range.",
                recommendation: "A diet rich in omega-3s, fibre, and movement supports healthy cholesterol."
            ),
            Biomarker(
                id: UUID(), profileId: pid, category: .cardiovascular,
                markerName: "HDL", value: 62, unit: "mg/dL",
                referenceMin: 40, referenceMax: 100,
                status: .optimal, displayName: "HDL (Good Cholesterol)",
                whatItMeans: "Your HDL looks good. Higher HDL is associated with cardiovascular wellness.",
                recommendation: "Regular exercise, healthy fats, and moderate alcohol support healthy HDL."
            ),
            Biomarker(
                id: UUID(), profileId: pid, category: .cardiovascular,
                markerName: "LDL", value: 105, unit: "mg/dL",
                referenceMin: 0, referenceMax: 130,
                status: .normal, displayName: "LDL Cholesterol",
                whatItMeans: "Your LDL looks within a normal range.",
                recommendation: "A Mediterranean-style diet with olive oil, nuts, and vegetables supports LDL balance."
            ),
        ]
    }

    // MARK: - Persistence

    private func loadProfile(userId: UUID) -> BiomarkerProfile? {
        let key = "\(userDefaultsKey).\(userId.uuidString)"
        guard let data = UserDefaults.standard.data(forKey: key),
              let profile = try? JSONDecoder().decode(BiomarkerProfile.self, from: data) else {
            return nil
        }
        return profile
    }

    private func saveProfile(_ profile: BiomarkerProfile, userId: UUID) {
        let key = "\(userDefaultsKey).\(userId.uuidString)"
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

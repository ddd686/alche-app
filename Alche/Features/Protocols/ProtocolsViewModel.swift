import Foundation

@Observable
@MainActor
final class ProtocolsViewModel {
    // MARK: - State

    var protocols: [HealthProtocol] = []
    var selectedGoal: ProtocolGoal?
    var userTier: MembershipTier = .free
    var todayLogs: [ProtocolLog] = []
    var activeProtocolId: UUID?
    var isLoading = false

    // MARK: - Filtered

    var filteredProtocols: [HealthProtocol] {
        guard let goal = selectedGoal else { return protocols }
        return protocols.filter { $0.goalTag == goal }
    }

    // MARK: - Actions

    func loadProtocols() async {
        isLoading = true

        // TODO: Wire to ProtocolServiceProtocol
        try? await Task.sleep(for: .seconds(0.4))

        userTier = .core
        activeProtocolId = Self.sampleProtocols.first?.id

        protocols = Self.sampleProtocols

        isLoading = false
    }

    func toggleStep(protocolId: UUID, stepIndex: Int) {
        if let logIndex = todayLogs.firstIndex(where: {
            $0.protocolId == protocolId && $0.stepIndex == stepIndex
        }) {
            todayLogs.remove(at: logIndex)
        } else {
            let log = ProtocolLog(
                id: UUID(),
                userId: UUID(),
                protocolId: protocolId,
                stepIndex: stepIndex,
                completed: true,
                loggedAt: Date()
            )
            todayLogs.append(log)
        }
    }

    func isStepCompleted(protocolId: UUID, stepIndex: Int) -> Bool {
        todayLogs.contains { $0.protocolId == protocolId && $0.stepIndex == stepIndex && $0.completed }
    }

    func completedSteps(for protocolId: UUID, totalSteps: Int) -> Int {
        todayLogs.filter { $0.protocolId == protocolId && $0.completed }.count
    }

    func isProtocolLocked(_ proto: HealthProtocol) -> Bool {
        let tierOrder: [MembershipTier] = [.free, .core, .pro, .premium]
        guard let userIndex = tierOrder.firstIndex(of: userTier),
              let requiredIndex = tierOrder.firstIndex(of: proto.tierRequired) else {
            return false
        }
        return requiredIndex > userIndex
    }

    // MARK: - Sample Data

    private static let sampleProtocols: [HealthProtocol] = [
        HealthProtocol(
            id: UUID(),
            name: "The Sleep Protocol",
            description: "A gentle evening routine to support deeper, more restorative sleep.",
            goalTag: .sleep,
            steps: [
                ProtocolStep(time: "18:00", action: "Last caffeine cutoff", category: .nutrition),
                ProtocolStep(time: "19:00", action: "Evening magnesium glycinate (400mg)", category: .supplement),
                ProtocolStep(time: "20:00", action: "Dim lights, warm tones only", category: .light),
                ProtocolStep(time: "21:00", action: "10 minutes breathing or journaling", category: .mindfulness),
                ProtocolStep(time: "21:30", action: "Screens off, room at 18\u{00B0}C", category: .sleep),
            ],
            tierRequired: .free
        ),
        HealthProtocol(
            id: UUID(),
            name: "Morning Energy Kickstart",
            description: "Start your day with light, movement, and targeted nutrition for sustained energy.",
            goalTag: .energy,
            steps: [
                ProtocolStep(time: "07:00", action: "10 min bright light exposure", category: .light, detail: "Step outside or use your Alche LED panel on daylight mode"),
                ProtocolStep(time: "07:15", action: "Cold water splash or 30s cold shower", category: .movement),
                ProtocolStep(time: "07:30", action: "Green smoothie with adaptogens", category: .nutrition, detail: "Try the Alche Energy Blend"),
                ProtocolStep(time: "08:00", action: "20 min walk or movement", category: .movement),
                ProtocolStep(time: "10:00", action: "First coffee (not before)", category: .nutrition),
            ],
            tierRequired: .free
        ),
        HealthProtocol(
            id: UUID(),
            name: "Post-Workout Recovery",
            description: "Optimise recovery after training with light therapy, nutrition, and rest.",
            goalTag: .recovery,
            steps: [
                ProtocolStep(time: "+0 min", action: "Red light therapy (15 min, 630nm)", category: .light, detail: "Book an LED session at Alche"),
                ProtocolStep(time: "+20 min", action: "Protein shake with collagen peptides", category: .nutrition),
                ProtocolStep(time: "+30 min", action: "500ml water with electrolytes", category: .hydration),
                ProtocolStep(time: "+60 min", action: "5 min contrast breathing", category: .mindfulness),
                ProtocolStep(time: "+90 min", action: "Gentle stretching or foam rolling", category: .movement),
            ],
            tierRequired: .core
        ),
        HealthProtocol(
            id: UUID(),
            name: "Glow From Within",
            description: "A skin-focused protocol combining light, hydration, and targeted nutrients.",
            goalTag: .glow,
            steps: [
                ProtocolStep(time: "Morning", action: "2 glasses warm lemon water", category: .hydration),
                ProtocolStep(time: "Morning", action: "Omega-3 + Vitamin D supplement", category: .supplement),
                ProtocolStep(time: "Midday", action: "LED red light session (660nm, 15 min)", category: .light),
                ProtocolStep(time: "Afternoon", action: "Collagen-rich smoothie", category: .nutrition, detail: "Try the Alche Glow Blend"),
                ProtocolStep(time: "Evening", action: "10 min facial massage + hydration", category: .mindfulness),
            ],
            tierRequired: .core
        ),
        HealthProtocol(
            id: UUID(),
            name: "Calm & Reset",
            description: "A nervous system regulation protocol for high-stress days.",
            goalTag: .calm,
            steps: [
                ProtocolStep(time: "Anytime", action: "5-5-5 box breathing (3 rounds)", category: .mindfulness),
                ProtocolStep(time: "Morning", action: "Ashwagandha + L-theanine", category: .supplement),
                ProtocolStep(time: "Afternoon", action: "20 min walk without phone", category: .movement),
                ProtocolStep(time: "Evening", action: "Warm amber light only", category: .light),
                ProtocolStep(time: "Evening", action: "Magnesium bath or foot soak", category: .mindfulness),
            ],
            tierRequired: .pro
        ),
        HealthProtocol(
            id: UUID(),
            name: "Gut Reset Week",
            description: "A 7-day protocol to support digestive health through nutrition, timing, and stress management.",
            goalTag: .gut,
            steps: [
                ProtocolStep(time: "Morning", action: "Warm water with apple cider vinegar", category: .hydration),
                ProtocolStep(time: "Morning", action: "Probiotic supplement (before food)", category: .supplement),
                ProtocolStep(time: "Lunch", action: "Fermented food with meal", category: .nutrition, detail: "Sauerkraut, kimchi, or kefir"),
                ProtocolStep(time: "18:00", action: "Last meal — 14h overnight fast", category: .nutrition),
                ProtocolStep(time: "Evening", action: "10 min gentle yoga or stretching", category: .movement),
            ],
            tierRequired: .pro
        ),
    ]
}

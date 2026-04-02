import Foundation

/// Mock implementation of DoctorSessionServiceProtocol.
/// Hard-codes 4 practitioners with realistic Berlin-flavored bios.
/// Generates 2 weeks of Mon-Fri availability slots.
/// Persists bookings and complimentary allowance in UserDefaults.
/// Pre-seeds: 1 upcoming + 2 past sessions for demo user.
final class MockDoctorSessionService: DoctorSessionServiceProtocol {

    // MARK: - Constants

    private let sessionsKey = "alche.mock.doctorSessions"
    private let allowanceKey = "alche.mock.complimentaryAllowance"
    private let availabilityKey = "alche.mock.practitionerAvailability"
    private let seededKey = "alche.mock.doctorSessions.seeded"

    private static let demoUserId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    // MARK: - Practitioners (hard-coded)

    private let practitioners: [Practitioner] = Practitioner.allPreviews

    // MARK: - Session Types (4 per practitioner)

    private func sessionTypesForPractitioner(_ practitionerId: UUID) -> [SessionType] {
        [
            SessionType(
                id: deterministicUUID(base: practitionerId, offset: 1),
                practitionerId: practitionerId,
                name: "Initial Consultation",
                durationMinutes: 60,
                priceCents: 12900,
                description: "Comprehensive first session to understand your wellness goals, review your protocols, and create a personalized guidance plan.",
                createdAt: Date().addingTimeInterval(-86400 * 180)
            ),
            SessionType(
                id: deterministicUUID(base: practitionerId, offset: 2),
                practitionerId: practitionerId,
                name: "Follow-Up Session",
                durationMinutes: 30,
                priceCents: 7900,
                description: "Review progress, adjust protocols, and address any new questions about your wellness journey.",
                createdAt: Date().addingTimeInterval(-86400 * 180)
            ),
            SessionType(
                id: deterministicUUID(base: practitionerId, offset: 3),
                practitionerId: practitionerId,
                name: "Protocol Review",
                durationMinutes: 30,
                priceCents: 7900,
                description: "Focused session to review and optimize your daily protocols based on recent Glow Scan and check-in data.",
                createdAt: Date().addingTimeInterval(-86400 * 180)
            ),
            SessionType(
                id: deterministicUUID(base: practitionerId, offset: 4),
                practitionerId: practitionerId,
                name: "Deep Dive Consultation",
                durationMinutes: 60,
                priceCents: 15900,
                description: "Extended session for in-depth exploration of a specific wellness area, including detailed protocol adjustments and lifestyle recommendations.",
                createdAt: Date().addingTimeInterval(-86400 * 180)
            ),
        ]
    }

    // MARK: - Practitioners

    func allPractitioners() async throws -> [Practitioner] {
        try await simulateDelay()
        return practitioners.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
    }

    func practitioner(id: UUID) async throws -> Practitioner {
        try await simulateDelay()
        guard let practitioner = practitioners.first(where: { $0.id == id }) else {
            throw DoctorSessionError.practitionerNotFound
        }
        return practitioner
    }

    func sessionTypes(practitionerId: UUID) async throws -> [SessionType] {
        try await simulateDelay()
        return sessionTypesForPractitioner(practitionerId)
    }

    // MARK: - Availability

    func availability(practitionerId: UUID, from: Date, to: Date) async throws -> [PractitionerAvailability] {
        try await simulateDelay()
        let slots = generateOrLoadAvailability(practitionerId: practitionerId, from: from, to: to)
        return slots.filter { slot in
            slot.date >= Calendar.current.startOfDay(for: from) &&
            slot.date <= Calendar.current.startOfDay(for: to)
        }
    }

    // MARK: - Booking

    func bookSession(
        userId: UUID,
        practitionerId: UUID,
        sessionTypeId: UUID,
        slotId: UUID,
        isComplimentary: Bool
    ) async throws -> DoctorSession {
        try await simulateDelay(min: 0.8, max: 1.2)

        // Find the slot
        var allAvailability = loadAllAvailability()
        guard let slotIndex = allAvailability.firstIndex(where: { $0.id == slotId }) else {
            throw DoctorSessionError.slotNotFound
        }

        let slot = allAvailability[slotIndex]
        guard slot.isAvailable else {
            throw DoctorSessionError.slotAlreadyBooked
        }

        // Find the session type
        let types = sessionTypesForPractitioner(practitionerId)
        guard let sessionType = types.first(where: { $0.id == sessionTypeId }) else {
            throw DoctorSessionError.sessionTypeNotFound
        }

        // Mark slot as booked
        allAvailability[slotIndex].isBooked = true
        allAvailability[slotIndex].sessionTypeId = sessionTypeId
        saveAllAvailability(allAvailability)

        // Create the session
        let session = DoctorSession(
            id: UUID(),
            userId: userId,
            practitionerId: practitionerId,
            sessionTypeId: sessionTypeId,
            availabilitySlotId: slotId,
            scheduledDate: slot.date,
            startTime: slot.startTime,
            endTime: Calendar.current.date(
                byAdding: .minute,
                value: sessionType.durationMinutes,
                to: slot.startTime
            ) ?? slot.endTime,
            status: .confirmed,
            isComplimentary: isComplimentary,
            priceCents: isComplimentary ? 0 : sessionType.priceCents,
            stripePaymentIntentId: isComplimentary ? nil : "pi_mock_\(UUID().uuidString.prefix(8))",
            cancellationReason: nil,
            cancelledAt: nil,
            createdAt: Date()
        )

        // Save session
        var sessions = loadSessions(userId: userId)
        sessions.append(session)
        saveSessions(sessions, userId: userId)

        // Update complimentary allowance if applicable
        if isComplimentary {
            var allowance = loadOrCreateAllowance(userId: userId, month: Date())
            allowance.used += 1
            saveAllowance(allowance, userId: userId)
        }

        return session
    }

    func cancelSession(sessionId: UUID, reason: String?) async throws {
        try await simulateDelay()

        // Find session across all user keys
        let allUserKeys = UserDefaults.standard.dictionaryRepresentation().keys.filter {
            $0.hasPrefix(sessionsKey)
        }

        for key in allUserKeys {
            guard let data = UserDefaults.standard.data(forKey: key),
                  var sessions = try? JSONDecoder().decode([DoctorSession].self, from: data),
                  let index = sessions.firstIndex(where: { $0.id == sessionId }) else {
                continue
            }

            let session = sessions[index]

            guard session.canCancel else {
                throw DoctorSessionError.cancellationNotAllowed
            }

            // Update session status
            sessions[index].status = .cancelledByMember
            sessions[index].cancellationReason = reason
            sessions[index].cancelledAt = Date()

            if let data = try? JSONEncoder().encode(sessions) {
                UserDefaults.standard.set(data, forKey: key)
            }

            // Free the availability slot
            var allAvailability = loadAllAvailability()
            if let slotIndex = allAvailability.firstIndex(where: { $0.id == session.availabilitySlotId }) {
                allAvailability[slotIndex].isBooked = false
                allAvailability[slotIndex].sessionTypeId = nil
                saveAllAvailability(allAvailability)
            }

            // Restore complimentary allowance if applicable
            if session.isComplimentary {
                var allowance = loadOrCreateAllowance(userId: session.userId, month: session.scheduledDate)
                allowance.used = max(0, allowance.used - 1)
                saveAllowance(allowance, userId: session.userId)
            }

            return
        }

        throw DoctorSessionError.sessionNotFound
    }

    // MARK: - User Sessions

    func upcomingSessions(userId: UUID) async throws -> [DoctorSession] {
        try await simulateDelay()
        seedDemoDataIfNeeded(userId: userId)
        let sessions = loadSessions(userId: userId)
        return sessions
            .filter { $0.isUpcoming }
            .sorted { $0.startTime < $1.startTime }
    }

    func pastSessions(userId: UUID) async throws -> [DoctorSession] {
        try await simulateDelay()
        seedDemoDataIfNeeded(userId: userId)
        let sessions = loadSessions(userId: userId)
        return sessions
            .filter { !$0.isUpcoming }
            .sorted { $0.startTime > $1.startTime }
    }

    // MARK: - Complimentary Tracking

    func complimentaryAllowance(userId: UUID, month: Date) async throws -> ComplimentarySessionAllowance {
        try await simulateDelay()
        return loadOrCreateAllowance(userId: userId, month: month)
    }

    // MARK: - Availability Generation

    private func generateOrLoadAvailability(
        practitionerId: UUID,
        from: Date,
        to: Date
    ) -> [PractitionerAvailability] {
        let key = "\(availabilityKey).\(practitionerId.uuidString)"

        // Try to load existing
        if let data = UserDefaults.standard.data(forKey: key),
           let existing = try? JSONDecoder().decode([PractitionerAvailability].self, from: data) {
            // Check if we have slots covering the requested range
            let requestedStart = Calendar.current.startOfDay(for: from)
            let hasRequiredSlots = existing.contains { $0.date >= requestedStart }
            if hasRequiredSlots {
                return existing
            }
        }

        // Generate fresh availability for 2 weeks from today
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var allSlots: [PractitionerAvailability] = []

        let slotHours: [(hour: Int, minute: Int)] = [
            (9, 0), (10, 30), (14, 0), (16, 0)
        ]

        for dayOffset in 0..<14 {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            let weekday = calendar.component(.weekday, from: day)

            // Skip weekends (1 = Sunday, 7 = Saturday)
            guard weekday >= 2 && weekday <= 6 else { continue }

            for (index, slotTime) in slotHours.enumerated() {
                guard let startTime = calendar.date(
                    bySettingHour: slotTime.hour,
                    minute: slotTime.minute,
                    second: 0,
                    of: day
                ) else { continue }

                // Default 60-minute slots
                guard let endTime = calendar.date(byAdding: .minute, value: 60, to: startTime) else { continue }

                // Some slots are pre-booked to show realistic patterns
                // Use deterministic logic based on practitioner + day + slot
                let bookingHash = abs(practitionerId.hashValue &+ dayOffset &* 7 &+ index &* 13)
                let isPreBooked = startTime < Date() || (bookingHash % 5 == 0)

                let slot = PractitionerAvailability(
                    id: deterministicUUID(base: practitionerId, offset: dayOffset * 100 + index + 1000),
                    practitionerId: practitionerId,
                    date: calendar.startOfDay(for: day),
                    startTime: startTime,
                    endTime: endTime,
                    isBooked: isPreBooked,
                    sessionTypeId: nil,
                    createdAt: today
                )
                allSlots.append(slot)
            }
        }

        // Persist generated availability
        if let data = try? JSONEncoder().encode(allSlots) {
            UserDefaults.standard.set(data, forKey: key)
        }

        return allSlots
    }

    // MARK: - Persistence

    private func loadSessions(userId: UUID) -> [DoctorSession] {
        let key = "\(sessionsKey).\(userId.uuidString)"
        guard let data = UserDefaults.standard.data(forKey: key),
              let sessions = try? JSONDecoder().decode([DoctorSession].self, from: data) else {
            return []
        }
        return sessions
    }

    private func saveSessions(_ sessions: [DoctorSession], userId: UUID) {
        let key = "\(sessionsKey).\(userId.uuidString)"
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func loadAllAvailability() -> [PractitionerAvailability] {
        var all: [PractitionerAvailability] = []
        for practitioner in practitioners {
            let key = "\(availabilityKey).\(practitioner.id.uuidString)"
            if let data = UserDefaults.standard.data(forKey: key),
               let slots = try? JSONDecoder().decode([PractitionerAvailability].self, from: data) {
                all.append(contentsOf: slots)
            }
        }
        return all
    }

    private func saveAllAvailability(_ slots: [PractitionerAvailability]) {
        // Group by practitioner and save each group
        let grouped = Dictionary(grouping: slots, by: \.practitionerId)
        for (practitionerId, practitionerSlots) in grouped {
            let key = "\(availabilityKey).\(practitionerId.uuidString)"
            if let data = try? JSONEncoder().encode(practitionerSlots) {
                UserDefaults.standard.set(data, forKey: key)
            }
        }
    }

    private func loadOrCreateAllowance(userId: UUID, month: Date) -> ComplimentarySessionAllowance {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: month)
        let periodStart = calendar.date(from: components)!
        let periodEnd = calendar.date(byAdding: .month, value: 1, to: periodStart)!

        let key = "\(allowanceKey).\(userId.uuidString).\(components.year!).\(components.month!)"

        if let data = UserDefaults.standard.data(forKey: key),
           let allowance = try? JSONDecoder().decode(ComplimentarySessionAllowance.self, from: data) {
            return allowance
        }

        // Create new allowance for this month (Longevity+ gets 1 free session)
        let allowance = ComplimentarySessionAllowance(
            id: UUID(),
            userId: userId,
            periodStart: periodStart,
            periodEnd: periodEnd,
            totalAllowed: 1,
            used: 0,
            createdAt: Date()
        )

        saveAllowance(allowance, userId: userId)
        return allowance
    }

    private func saveAllowance(_ allowance: ComplimentarySessionAllowance, userId: UUID) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: allowance.periodStart)
        let key = "\(allowanceKey).\(userId.uuidString).\(components.year!).\(components.month!)"

        if let data = try? JSONEncoder().encode(allowance) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    // MARK: - Demo Data Seeding

    private func seedDemoDataIfNeeded(userId: UUID) {
        let key = "\(seededKey).\(userId.uuidString)"
        guard !UserDefaults.standard.bool(forKey: key) else { return }

        // Pre-seed: 1 upcoming + 2 past sessions
        let calendar = Calendar.current

        // Upcoming: Dr. Hoffmann Follow-Up, 3 days from now at 10:30
        let upcomingDate = calendar.date(byAdding: .day, value: 3, to: Date())!
        let upcomingStart = calendar.date(bySettingHour: 10, minute: 30, second: 0, of: upcomingDate)!
        let upcomingEnd = calendar.date(byAdding: .minute, value: 30, to: upcomingStart)!

        let hoffmannTypes = sessionTypesForPractitioner(Practitioner.previewHoffmann.id)
        let reevesTypes = sessionTypesForPractitioner(Practitioner.previewReeves.id)

        let upcomingSession = DoctorSession(
            id: UUID(uuidString: "C1000001-0000-0000-0000-000000000001")!,
            userId: userId,
            practitionerId: Practitioner.previewHoffmann.id,
            sessionTypeId: hoffmannTypes[1].id, // Follow-Up
            availabilitySlotId: UUID(),
            scheduledDate: calendar.startOfDay(for: upcomingDate),
            startTime: upcomingStart,
            endTime: upcomingEnd,
            status: .confirmed,
            isComplimentary: false,
            priceCents: 7900,
            stripePaymentIntentId: "pi_mock_seed_001",
            cancellationReason: nil,
            cancelledAt: nil,
            createdAt: Date().addingTimeInterval(-86400 * 2)
        )

        // Past 1: Dr. Reeves Initial Consultation, 3 weeks ago
        let past1Date = calendar.date(byAdding: .day, value: -21, to: Date())!
        let past1Start = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: past1Date)!
        let past1End = calendar.date(byAdding: .minute, value: 60, to: past1Start)!

        let pastSession1 = DoctorSession(
            id: UUID(uuidString: "C1000001-0000-0000-0000-000000000002")!,
            userId: userId,
            practitionerId: Practitioner.previewReeves.id,
            sessionTypeId: reevesTypes[0].id, // Initial Consultation
            availabilitySlotId: UUID(),
            scheduledDate: calendar.startOfDay(for: past1Date),
            startTime: past1Start,
            endTime: past1End,
            status: .completed,
            isComplimentary: false,
            priceCents: 12900,
            stripePaymentIntentId: "pi_mock_seed_002",
            cancellationReason: nil,
            cancelledAt: nil,
            createdAt: past1Date.addingTimeInterval(-86400 * 5)
        )

        // Past 2: Dr. Hoffmann Follow-Up, 6 weeks ago (complimentary)
        let past2Date = calendar.date(byAdding: .day, value: -42, to: Date())!
        let past2Start = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: past2Date)!
        let past2End = calendar.date(byAdding: .minute, value: 30, to: past2Start)!

        let pastSession2 = DoctorSession(
            id: UUID(uuidString: "C1000001-0000-0000-0000-000000000003")!,
            userId: userId,
            practitionerId: Practitioner.previewHoffmann.id,
            sessionTypeId: hoffmannTypes[1].id, // Follow-Up
            availabilitySlotId: UUID(),
            scheduledDate: calendar.startOfDay(for: past2Date),
            startTime: past2Start,
            endTime: past2End,
            status: .completed,
            isComplimentary: true,
            priceCents: 0,
            stripePaymentIntentId: nil,
            cancellationReason: nil,
            cancelledAt: nil,
            createdAt: past2Date.addingTimeInterval(-86400 * 7)
        )

        saveSessions([upcomingSession, pastSession1, pastSession2], userId: userId)
        UserDefaults.standard.set(true, forKey: key)
    }

    // MARK: - Helpers

    private func simulateDelay(min: Double = 0.3, max: Double = 0.8) async throws {
        let delay = Double.random(in: min...max)
        try await Task.sleep(for: .seconds(delay))
    }

    /// Creates a deterministic UUID from a base UUID and an integer offset.
    /// Ensures the same practitioner + offset always produces the same UUID.
    private func deterministicUUID(base: UUID, offset: Int) -> UUID {
        let baseString = base.uuidString.replacingOccurrences(of: "-", with: "")
        let hash = abs(baseString.hashValue &+ offset)
        let hexString = String(format: "%032X", hash)
        let truncated = String(hexString.suffix(32))
        let padded = truncated.padding(toLength: 32, withPad: "0", startingAt: 0)

        let p1 = padded.prefix(8)
        let p2 = padded.dropFirst(8).prefix(4)
        let p3 = padded.dropFirst(12).prefix(4)
        let p4 = padded.dropFirst(16).prefix(4)
        let p5 = padded.dropFirst(20).prefix(12)

        return UUID(uuidString: "\(p1)-\(p2)-\(p3)-\(p4)-\(p5)") ?? UUID()
    }
}

// MARK: - Errors

enum DoctorSessionError: LocalizedError {
    case practitionerNotFound
    case sessionTypeNotFound
    case slotNotFound
    case slotAlreadyBooked
    case cancellationNotAllowed
    case sessionNotFound
    case complimentaryNotAvailable

    var errorDescription: String? {
        switch self {
        case .practitionerNotFound:
            "Practitioner not found."
        case .sessionTypeNotFound:
            "Session type not found."
        case .slotNotFound:
            "Time slot not found."
        case .slotAlreadyBooked:
            "This time slot has already been booked."
        case .cancellationNotAllowed:
            "Sessions can only be cancelled at least 24 hours before the scheduled time."
        case .sessionNotFound:
            "Session not found."
        case .complimentaryNotAvailable:
            "You have already used your complimentary session this month."
        }
    }
}

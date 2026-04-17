import Foundation

// MARK: - Player Progress Ledger
struct WayfarerLedger {
    var currentEpoch: Int = 1
    var accruedBounty: Int = 0
    var totalHoardedCoins: Int = 0
    var apexEpochReached: Int = 0
    var apexBountyRecord: Int = 0
    var relicInventory: [ArcanaRelicKind: Int] = [
        .serendipityCharm: 0,
        .clairvoyanceLens: 0,
        .amplificationSigil: 0
    ]
    var amplificationActiveFlag: Bool = false

    var portalCountForEpoch: Int {
        switch currentEpoch {
        case 1:
            return 2
        case 2...5:
            return 3
        case 6...10:
            return 4
        case 11...20:
            return 5
        case 21...30:
            return 6
        case 31...50:
            return 7
        case 51...80:
            return 8
        case 81...100:
            return 9
        default:
            return 10
        }
    }

    var epochBountyReward: Int {
        let baseReward: Int
        switch currentEpoch {
        case 1: baseReward = 10
        case 2: baseReward = 20
        case 3: baseReward = 30
        case 4: baseReward = 50
        case 5: baseReward = 60
        case 6: baseReward = 70
        case 7: baseReward = 80
        case 8: baseReward = 90
        case 9: baseReward = 100
        case 10...100: baseReward = 150
        default: baseReward = 1000
        }
        return amplificationActiveFlag ? baseReward * 2 : baseReward
    }

    mutating func advanceEpoch() {
        accruedBounty += epochBountyReward
        currentEpoch += 1
        amplificationActiveFlag = false
    }

    mutating func cashOutBounty() {
        totalHoardedCoins += accruedBounty
        if currentEpoch - 1 > apexEpochReached {
            apexEpochReached = currentEpoch - 1
        }
        if accruedBounty > apexBountyRecord {
            apexBountyRecord = accruedBounty
        }
        resetExpedition()
    }

    mutating func forfeitExpedition() {
        if currentEpoch - 1 > apexEpochReached {
            apexEpochReached = currentEpoch - 1
        }
        if accruedBounty > apexBountyRecord {
            apexBountyRecord = accruedBounty
        }
        resetExpedition()
    }

    mutating func resetExpedition() {
        currentEpoch = 1
        accruedBounty = 0
        amplificationActiveFlag = false
    }

    mutating func procureRelic(_ kind: ArcanaRelicKind) -> Bool {
        let relic = ArcanaRelic(relicKind: kind, stockpileCount: 0)
        guard totalHoardedCoins >= relic.tariffCost else { return false }
        totalHoardedCoins -= relic.tariffCost
        relicInventory[kind, default: 0] += 1
        return true
    }

    mutating func expendRelic(_ kind: ArcanaRelicKind) -> Bool {
        guard let count = relicInventory[kind], count > 0 else { return false }
        relicInventory[kind] = count - 1
        if kind == .amplificationSigil {
            amplificationActiveFlag = true
        }
        return true
    }

    func relicStockpile(_ kind: ArcanaRelicKind) -> Int {
        return relicInventory[kind, default: 0]
    }
}

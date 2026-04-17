import Foundation

// MARK: - Persistent Storage Manager
final class ObsidianArchive {

    static let sharedVault = ObsidianArchive()

    private let storageConduit = UserDefaults.standard

    private enum VaultCipherKey: String {
        case hoardedCoins = "dc_hoarded_coins"
        case apexEpoch = "dc_apex_epoch"
        case apexBounty = "dc_apex_bounty"
        case relicSerendipity = "dc_relic_serendipity"
        case relicClairvoyance = "dc_relic_clairvoyance"
        case relicAmplification = "dc_relic_amplification"
        case acousticEnabled = "dc_acoustic_enabled"
        case totalExpeditions = "dc_total_expeditions"
    }

    private init() {}

    // MARK: - Coin Hoard
    func stashCoinHoard(_ amount: Int) {
        storageConduit.set(amount, forKey: VaultCipherKey.hoardedCoins.rawValue)
    }

    func retrieveCoinHoard() -> Int {
        return storageConduit.integer(forKey: VaultCipherKey.hoardedCoins.rawValue)
    }

    // MARK: - Apex Records
    func stashApexEpoch(_ epoch: Int) {
        let current = retrieveApexEpoch()
        if epoch > current {
            storageConduit.set(epoch, forKey: VaultCipherKey.apexEpoch.rawValue)
        }
    }

    func retrieveApexEpoch() -> Int {
        return storageConduit.integer(forKey: VaultCipherKey.apexEpoch.rawValue)
    }

    func stashApexBounty(_ bounty: Int) {
        let current = retrieveApexBounty()
        if bounty > current {
            storageConduit.set(bounty, forKey: VaultCipherKey.apexBounty.rawValue)
        }
    }

    func retrieveApexBounty() -> Int {
        return storageConduit.integer(forKey: VaultCipherKey.apexBounty.rawValue)
    }

    // MARK: - Relic Inventory
    func stashRelicCount(_ kind: ArcanaRelicKind, count: Int) {
        let key: VaultCipherKey
        switch kind {
        case .serendipityCharm: key = .relicSerendipity
        case .clairvoyanceLens: key = .relicClairvoyance
        case .amplificationSigil: key = .relicAmplification
        }
        storageConduit.set(count, forKey: key.rawValue)
    }

    func retrieveRelicCount(_ kind: ArcanaRelicKind) -> Int {
        let key: VaultCipherKey
        switch kind {
        case .serendipityCharm: key = .relicSerendipity
        case .clairvoyanceLens: key = .relicClairvoyance
        case .amplificationSigil: key = .relicAmplification
        }
        return storageConduit.integer(forKey: key.rawValue)
    }

    // MARK: - Sound Toggle
    func stashAcousticPreference(_ enabled: Bool) {
        storageConduit.set(enabled, forKey: VaultCipherKey.acousticEnabled.rawValue)
    }

    func retrieveAcousticPreference() -> Bool {
        if storageConduit.object(forKey: VaultCipherKey.acousticEnabled.rawValue) == nil {
            return true
        }
        return storageConduit.bool(forKey: VaultCipherKey.acousticEnabled.rawValue)
    }

    // MARK: - Expedition Count
    func incrementExpeditionTally() {
        let current = retrieveExpeditionTally()
        storageConduit.set(current + 1, forKey: VaultCipherKey.totalExpeditions.rawValue)
    }

    func retrieveExpeditionTally() -> Int {
        return storageConduit.integer(forKey: VaultCipherKey.totalExpeditions.rawValue)
    }

    // MARK: - Full Ledger Sync
    func synchronizeLedger(_ ledger: WayfarerLedger) {
        stashCoinHoard(ledger.totalHoardedCoins)
        stashApexEpoch(ledger.apexEpochReached)
        stashApexBounty(ledger.apexBountyRecord)
        for kind in ArcanaRelicKind.allCases {
            stashRelicCount(kind, count: ledger.relicStockpile(kind))
        }
    }

    func reconstituteLedger() -> WayfarerLedger {
        var ledger = WayfarerLedger()
        ledger.totalHoardedCoins = retrieveCoinHoard()
        ledger.apexEpochReached = retrieveApexEpoch()
        ledger.apexBountyRecord = retrieveApexBounty()
        for kind in ArcanaRelicKind.allCases {
            ledger.relicInventory[kind] = retrieveRelicCount(kind)
        }
        return ledger
    }
}

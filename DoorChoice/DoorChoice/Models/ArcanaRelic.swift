import Foundation

// MARK: - Relic (Item/Power-up) Model
enum ArcanaRelicKind: String, CaseIterable {
    case serendipityCharm = "item_lucky"
    case clairvoyanceLens = "item_xray"
    case amplificationSigil = "item_double"
}

struct ArcanaRelic {
    let relicKind: ArcanaRelicKind
    var stockpileCount: Int

    var tariffCost: Int {
        switch relicKind {
        case .serendipityCharm:
            return 20
        case .clairvoyanceLens:
            return 50
        case .amplificationSigil:
            return 100
        }
    }

    var displayMoniker: String {
        switch relicKind {
        case .serendipityCharm:
            return "Lucky Charm"
        case .clairvoyanceLens:
            return "X-Ray Vision"
        case .amplificationSigil:
            return "Double Reward"
        }
    }

    var synopsisText: String {
        switch relicKind {
        case .serendipityCharm:
            return "Turns a danger door into a lucky door worth 50 coins"
        case .clairvoyanceLens:
            return "Reveals one danger door with a warning sign"
        case .amplificationSigil:
            return "Doubles your coin reward for the current stage"
        }
    }

    var iconAssetMoniker: String {
        return relicKind.rawValue
    }
}

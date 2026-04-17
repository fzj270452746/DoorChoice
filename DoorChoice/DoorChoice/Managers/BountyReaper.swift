import Foundation

// MARK: - Reward Calculation Manager
final class BountyReaper {

    static let sharedCollector = BountyReaper()

    private init() {}

    func computeEpochReward(epoch: Int, amplified: Bool) -> Int {
        let baseReward: Int
        switch epoch {
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
        return amplified ? baseReward * 2 : baseReward
    }

    func fortuneBlessingBounty() -> Int {
        return 50
    }

    func computeFinalTally(epochsCleared: Int, coinsAccrued: Int) -> Int {
        return epochsCleared * 100 + coinsAccrued
    }
}

import Foundation
import GameplayKit

// MARK: - Door Generation & Logic Arbiter
final class AugurArbiter {

    static let sharedOracle = AugurArbiter()

    private let entropySource = GKRandomSource.sharedRandom()

    private init() {}

    func conjurePortcullisArray(
        portalCount: Int,
        serendipityActive: Bool = false
    ) -> [PortcullisEssence] {
        guard portalCount >= 2 else {
            return [PortcullisEssence(kindVariant: .sanctuary, sequenceIndex: 0)]
        }

        let sanctuaryIndex = entropySource.nextInt(upperBound: portalCount)

        var luckyIndex: Int? = nil
        if serendipityActive {
            var candidate = entropySource.nextInt(upperBound: portalCount)
            while candidate == sanctuaryIndex {
                candidate = entropySource.nextInt(upperBound: portalCount)
            }
            luckyIndex = candidate
        }

        var portcullisArray: [PortcullisEssence] = []
        let perilVariants = PortcullisEssence.perilVariants()

        for i in 0..<portalCount {
            if i == sanctuaryIndex {
                portcullisArray.append(PortcullisEssence(kindVariant: .sanctuary, sequenceIndex: i))
            } else if let luckyIdx = luckyIndex, i == luckyIdx {
                portcullisArray.append(PortcullisEssence(kindVariant: .fortuneBlessing, sequenceIndex: i))
            } else {
                let randomPeril = perilVariants[entropySource.nextInt(upperBound: perilVariants.count)]
                portcullisArray.append(PortcullisEssence(kindVariant: randomPeril, sequenceIndex: i))
            }
        }

        return portcullisArray
    }

    func selectClairvoyanceTarget(from portcullisArray: [PortcullisEssence]) -> Int? {
        let dangerIndices = portcullisArray.enumerated().compactMap { index, essence -> Int? in
            if !essence.isSanctuary && !essence.isFortuneBlessing {
                return index
            }
            return nil
        }
        guard !dangerIndices.isEmpty else { return nil }
        return dangerIndices[entropySource.nextInt(upperBound: dangerIndices.count)]
    }
}

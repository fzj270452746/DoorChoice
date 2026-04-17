import Foundation

// MARK: - Door Essence
enum PortcullisKind: CaseIterable {
    case sanctuary
    case fiendAmbush
    case spikeSnare
    case abyssPlunge
    case venomMiasma
    case detonation
    case fortuneBlessing
}

struct PortcullisEssence {
    let kindVariant: PortcullisKind
    let sequenceIndex: Int

    var isSanctuary: Bool {
        return kindVariant == .sanctuary
    }

    var isFortuneBlessing: Bool {
        return kindVariant == .fortuneBlessing
    }

    var revealedAssetMoniker: String {
        switch kindVariant {
        case .sanctuary:
            return "door_safe_open"
        case .fiendAmbush:
            return "door_monster_open"
        case .spikeSnare:
            return "door_trap_spikes"
        case .abyssPlunge:
            return "door_trap_fall"
        case .venomMiasma:
            return "door_trap_poison"
        case .detonation:
            return "door_explosion"
        case .fortuneBlessing:
            return "door_lucky_open"
        }
    }

    var perilCaption: String {
        switch kindVariant {
        case .sanctuary:
            return "Safe Passage!"
        case .fiendAmbush:
            return "A Monster Lurks!"
        case .spikeSnare:
            return "Spike Trap!"
        case .abyssPlunge:
            return "Bottomless Pit!"
        case .venomMiasma:
            return "Poison Gas!"
        case .detonation:
            return "Explosion!"
        case .fortuneBlessing:
            return "Lucky Bonus!"
        }
    }

    var perilSubCaption: String {
        switch kindVariant {
        case .sanctuary:
            return "You found the safe door.\nOnward to the next stage!"
        case .fiendAmbush:
            return "A fearsome creature jumped out\nand ended your journey!"
        case .spikeSnare:
            return "Sharp spikes emerged\nfrom the ground!"
        case .abyssPlunge:
            return "The floor collapsed\ninto a dark abyss!"
        case .venomMiasma:
            return "Toxic fumes filled\nthe corridor!"
        case .detonation:
            return "The door exploded\nin a fiery blast!"
        case .fortuneBlessing:
            return "Fortune smiles upon you!\n+50 bonus coins!"
        }
    }

    static func perilVariants() -> [PortcullisKind] {
        return [.fiendAmbush, .spikeSnare, .abyssPlunge, .venomMiasma, .detonation]
    }
}

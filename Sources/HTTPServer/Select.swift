import Glibc 

func FD_ZERO(_ set: inout fd_set) {
    set.__fds_bits = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
}

func FD_SET(_ fd: Int32, _ set: inout fd_set) {
    let intOffset = Int(fd / 16)
    let bitOffset: Int = Int(fd % 16)
    let mask: Int = 1 << bitOffset
    switch intOffset {
        case 0: set.__fds_bits.0 = set.__fds_bits.0 | mask
        case 1: set.__fds_bits.1 = set.__fds_bits.1 | mask
        case 2: set.__fds_bits.2 = set.__fds_bits.2 | mask
        case 3: set.__fds_bits.3 = set.__fds_bits.3 | mask
        case 4: set.__fds_bits.4 = set.__fds_bits.4 | mask
        case 5: set.__fds_bits.5 = set.__fds_bits.5 | mask
        case 6: set.__fds_bits.6 = set.__fds_bits.6 | mask
        case 7: set.__fds_bits.7 = set.__fds_bits.7 | mask
        case 8: set.__fds_bits.8 = set.__fds_bits.8 | mask
        case 9: set.__fds_bits.9 = set.__fds_bits.9 | mask
        case 10: set.__fds_bits.10 = set.__fds_bits.10 | mask
        case 11: set.__fds_bits.11 = set.__fds_bits.11 | mask
        case 12: set.__fds_bits.12 = set.__fds_bits.12 | mask
        case 13: set.__fds_bits.13 = set.__fds_bits.13 | mask
        case 14: set.__fds_bits.14 = set.__fds_bits.14 | mask
        case 15: set.__fds_bits.15 = set.__fds_bits.15 | mask
        default: break
    }
}

func FD_CLR(_ fd: Int32, _ set: inout fd_set) {
    let intOffset = Int(fd / 16)
    let bitOffset: Int = Int(fd % 16)
    let mask: Int = ~(1 << bitOffset)
    switch intOffset {
        case 0: set.__fds_bits.0 = set.__fds_bits.0 & mask
        case 1: set.__fds_bits.1 = set.__fds_bits.1 & mask
        case 2: set.__fds_bits.2 = set.__fds_bits.2 & mask
        case 3: set.__fds_bits.3 = set.__fds_bits.3 & mask
        case 4: set.__fds_bits.4 = set.__fds_bits.4 & mask
        case 5: set.__fds_bits.5 = set.__fds_bits.5 & mask
        case 6: set.__fds_bits.6 = set.__fds_bits.6 & mask
        case 7: set.__fds_bits.7 = set.__fds_bits.7 & mask
        case 8: set.__fds_bits.8 = set.__fds_bits.8 & mask
        case 9: set.__fds_bits.9 = set.__fds_bits.9 & mask
        case 10: set.__fds_bits.10 = set.__fds_bits.10 & mask
        case 11: set.__fds_bits.11 = set.__fds_bits.11 & mask
        case 12: set.__fds_bits.12 = set.__fds_bits.12 & mask
        case 13: set.__fds_bits.13 = set.__fds_bits.13 & mask
        case 14: set.__fds_bits.14 = set.__fds_bits.14 & mask
        case 15: set.__fds_bits.15 = set.__fds_bits.15 & mask
        default: break
    }
}

func FD_ISSET(_ fd: Int32, _ set: inout fd_set) -> Bool {
    let intOffset = Int(fd / 16)
    let bitOffset = Int(fd % 16)
    let mask: Int = 1 << bitOffset
    switch intOffset {
        case 0: return set.__fds_bits.0 & mask != 0
        case 1: return set.__fds_bits.1 & mask != 0
        case 2: return set.__fds_bits.2 & mask != 0
        case 3: return set.__fds_bits.3 & mask != 0
        case 4: return set.__fds_bits.4 & mask != 0
        case 5: return set.__fds_bits.5 & mask != 0
        case 6: return set.__fds_bits.6 & mask != 0
        case 7: return set.__fds_bits.7 & mask != 0
        case 8: return set.__fds_bits.8 & mask != 0
        case 9: return set.__fds_bits.9 & mask != 0
        case 10: return set.__fds_bits.10 & mask != 0
        case 11: return set.__fds_bits.11 & mask != 0
        case 12: return set.__fds_bits.12 & mask != 0
        case 13: return set.__fds_bits.13 & mask != 0
        case 14: return set.__fds_bits.14 & mask != 0
        case 15: return set.__fds_bits.15 & mask != 0
        default: return false
    }

}

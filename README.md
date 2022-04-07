# MetaFashion Contracts

## Requirements
Name:           MetaFashion?
Token Symbol:   MFHQ?
Total Supply:   10,000
Reserved:       ???

### VIP List
Cost:                           .075 ether
Max transactions:               1
Max mints per transaction:      3

### Public
Cost: .085 ether
Max transactions:               3
Max mints per transaction:      5

## Features:
Pausable:       Yes (Privileged accounts will be able to pause the functionality marked as whenNotPaused. Useful for emergency response.)
Storage:        IPFS (URI updateable)

## Access Control
Ownable:        A single account authorized for all privileged actions.

## Upgradeability ??
Transparent     Uses more complex proxy with higher overhead, requires less changes in your contract.
UUPS            Uses simpler proxy with less overhead, requires including extra code in your contract. Allows flexibility for authorizing upgrades.
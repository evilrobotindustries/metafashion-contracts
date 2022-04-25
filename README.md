# MetaFashion NFT Contract (ERC721)

## Requirements
- Name:           MetaFashion
- Token Symbol:   MFT
- Total Supply:   10,000 (should be able to be reduced if required)
- Reserved:       100 for giveaways
- VIP List
    - Cost: .075 Ether
    - Max transactions: 1
    - Max mints per transaction: 3
    - Total limit: no fixed limit, based on time
- Public
    - Cost: .085 ether
    - Max transactions: 3
    - Max mints per transaction: 5
- Withdrawal
    - Split between community and MetaFashion wallet
- Royalties - use market place
- License?

## Assumptions:
- Access Control: Single owner of the contract, authorized for all privileged actions
- Burnable: Tokens should be burnable, allowing for any future burn mechanics
- Immutable - the contract has no upgradeability requirements, meaning that it needs to be fully agreed before final sign-off. 
    - Note: Contract code therefore cannot be changed once deployed to mainnet, unless to a new address.
- Pausable: Owner will be able to pause the contract functionality (useful for emergency response)
- Sequential: Token identifiers should be sequential (i.e. a max VIP batch mint would result in tokens 100,101,102 being issued). Noted here due to the proposed ERC721 implementation below. 
- Storage: Metadata to be stored on IPFS, so contract's base URI must be updateable. This will allow for initial placeholder metadata/image, allow for a reveal after mint and most importantly, allow the metadata/images to be updated should there be any issues discovered.

## Proposal
The [ERC721A](https://www.erc721a.org) implementation developed by the the Azuki project, is proposed in order to allow gas efficiencies when minting multiple tokens in a single transaction. More information can be found at https://www.azuki.com/erc721a. This implementation does involve increased tranfer costs, effectively deferring the potential costs at mint to later in the token lifecycle, but their [illustration of lower fees](https://chiru-labs.github.io/ERC721A/#/design?id=lower-fees) shows the net costs as still being lower than the standard ERC721 standard. Note: Token holders should be advised to [transfer tokens in sequence](https://chiru-labs.github.io/ERC721A/#/tips?id=transfers) wherever possible.

Finally, [OpenZeppelin](https://openzeppelin.com) libraries are to be  used in all other cases to maximise security. More information available at https://docs.openzeppelin.com/contracts/4.x/api/token/erc721 and https://github.com/OpenZeppelin/openzeppelin-contracts.

### Testing
All smart contract functionality will be fully tested using the [forge](https://github.com/gakonst/foundry/tree/master/forge) testing framework. Tests are written in Solidity. The current status of tests can be seen below. 

[![Forge Tests](https://github.com/evilrobotindustries/metafashion-contracts/actions/workflows/foundry-tests.yml/badge.svg)](https://github.com/evilrobotindustries/metafashion-contracts/actions/workflows/foundry-tests.yml) [![Solhint Security and Style Guide Validation](https://github.com/evilrobotindustries/metafashion-contracts/actions/workflows/solhint.yml/badge.svg)](https://github.com/evilrobotindustries/metafashion-contracts/actions/workflows/solhint.yml)

### Auditing
The contract will be audited through automated testing tools such as ConsenSys [MythX](https://mythx.io/)/[Mythril](https://github.com/ConsenSys/mythril) and [Slither](https://github.com/crytic/slither), but a manual audit by a smart contract security professional must still be carried out. The current status of automated audits can be seen below. 

[![Mythril Analysis](https://github.com/evilrobotindustries/metafashion-contracts/actions/workflows/mythril.yml/badge.svg)](https://github.com/evilrobotindustries/metafashion-contracts/actions/workflows/mythril.yml) [![Slither Analysis](https://github.com/evilrobotindustries/metafashion-contracts/actions/workflows/slither.yml/badge.svg)](https://github.com/evilrobotindustries/metafashion-contracts/actions/workflows/slither.yml)

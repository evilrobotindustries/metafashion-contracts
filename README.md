# MetaFashion NFT Contract (ERC721)

## Requirements
- Name:           MetaFashion?
- Token Symbol:   MFHQ?
- Total Supply:   10,000
- Reserved:       100 for giveaways???
- VIP List
    - Cost: .075 Ether
    - Max transactions: 1
    - Max mints per transaction:      3
    - Total limit: based on time/reserved quantity/max mints * by VIP list address?
- Public
    - Cost: .085 ether
    - Max transactions:               3
    - Max mints per transaction:      5
- Withdrawal
    - Single withdrawal address vs multiple, based on pre-defined split?
- Adjustable prices/total supply?: cater for scenario whereby things dont sell out
- Royalties - implement standard into contract vs flexibility provided by market places?
- License?

## Assumptions:
- Sequential: Token identifiers should be sequential (i.e. a max VIP batch mint would result in tokens 100,101,102 being issued). Noted here due to the proposed ERC721 implementation below. 
- Pausable: Privileged accounts will be able to pause the contract functionality (useful for emergency response)
- Burnable: Tokens should be burnable, allowing for any future burn mechanics
- Access Control: Single owner of the contract, authorized for all privileged actions
- Immutable - the contract has no upgradeability requirements, meaning that it needs to be fully agreed before final sign-off as it cannot be changed once it has been deployed to mainnet
- Storage: Metadata to be stored on IPFS, so contract's base URI must be updateable. This will allow for initial placeholder metadata/image,  allow for a reveal after mint and most importantly, allow the metadata/images to be updated should there be any issues discovered.

## Proposal
The [ERC721A](https://www.erc721a.org) implementation developed by the the Azuki project, is proposed in order to allow gas efficiencies when minting multiple tokens in a single transaction. More information can be found at https://www.azuki.com/erc721a. This implementation does involve increased tranfer costs, effectively deferring the potential costs at mint to later in the token lifecycle, but their [illustration of lower fees](https://chiru-labs.github.io/ERC721A/#/design?id=lower-fees) shows the net costs as still being lower than the standard ERC721 standard. Note: Token holders should be advised to [transfer tokens in sequence](https://chiru-labs.github.io/ERC721A/#/tips?id=transfers) wherever possible.

Finally, [OpenZeppelin](https://openzeppelin.com) libraries are to be  used in all other cases to maximise security. More information available at https://docs.openzeppelin.com/contracts/4.x/api/token/erc721 and https://github.com/OpenZeppelin/openzeppelin-contracts.

### Testing
All smart contract functionality will be fully tested using the [forge](https://github.com/gakonst/foundry/tree/master/forge) testing framework. Tests are written in Solidity. The current status of tests can be see below. 

[![Tests](https://github.com/evilrobotindustries/metafashion-contracts/actions/workflows/foundry-tests.yml/badge.svg)](https://github.com/evilrobotindustries/metafashion-contracts/actions/workflows/foundry-tests.yml)
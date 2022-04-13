// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ERC721A/ERC721A.sol";
import "ERC721A/extensions/ERC721ABurnable.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/security/Pausable.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

error TestError();
error VIPMintInactive();
error NotVIP();
error TransactionMintLimitExceeded();
error TransactionLimitExceeded();
error MintingPaused();

contract MetaFashion is ERC721A, ERC721ABurnable, Pausable, Ownable {

    enum ContractStatus {
        Paused,
        VIPOnly,
        Public
    }

    // state variables

    /// @notice The maximum number of mints per transaction.
    uint8 private constant _PUBLIC_MAX_MINT = 5;
    uint8 private constant _PUBLIC_MAX_TRANSACTIONS = 3;
    uint256 private constant _PUBLIC_PRICE = 0.085 ether;
    uint8 private constant _VIP_MAX_MINT = 3;
    uint8 private constant _VIP_MAX_TRANSACTIONS = 1;
    uint256 private constant _VIP_PRICE = 0.075 ether;

    ContractStatus private _status = ContractStatus.Paused;
    string private _tokenBaseURI;
    bytes32 private _vipMerkleRoot;
    
    // events

    // modifiers
    modifier whenVIP() {
        // TODO
        if (_status != ContractStatus.VIPOnly) revert VIPMintInactive();
        _;
    }

    // constructor

    constructor(bytes32 vipMerkleRoot) ERC721A("MetaFashion", "MFHQ") {

        _vipMerkleRoot = vipMerkleRoot;
        pause(); // Pause until explicitly enabled
    }

    // external

    function vipMint(uint8 quantity, bytes32[] calldata proof) external payable whenNotPaused whenVIP {
        if (quantity > _VIP_MAX_MINT) revert TransactionMintLimitExceeded();
        // Validate VIP eligibility
        if (
            !MerkleProof.verify(
            proof,
            _vipMerkleRoot,
            keccak256(abi.encodePacked(_msgSender()))
        )
        ) revert NotVIP();

        // VIP mint limited to a single transaction, so check if any minted
        uint256 minted = _numberMinted(_msgSender());
        if (minted > 0) revert TransactionLimitExceeded();

        // Safe minting is reentrant safe and doubles as an gas-optimized reentrancy guard since V3
        // https://chiru-labs.github.io/ERC721A/#/erc721a?id=_mint
        _safeMint(_msgSender(), quantity);
    }

    function publicMint(uint8 quantity) external payable whenNotPaused {
        if (quantity > _PUBLIC_MAX_MINT) revert TransactionMintLimitExceeded();
        // Check public transaction limit
        uint64 transactions = _getAux(_msgSender()) + 1;
        if (transactions > _PUBLIC_MAX_TRANSACTIONS)
            revert TransactionLimitExceeded();

        // Safe minting is reentrant safe and doubles as an gas-optimized reentrancy guard since V3 
        // https://chiru-labs.github.io/ERC721A/#/erc721a?id=_mint
        _safeMint(_msgSender(), quantity);
        _setAux(_msgSender(), transactions); // Update number of transactions
    }


    // public

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function setBaseURI(string calldata uri) public onlyOwner {
        _tokenBaseURI = uri;
    }

    function setContractStatus(ContractStatus status) public onlyOwner {
        _status = status;
    }

    // internal

    function _baseURI() internal view override returns (string memory) {
        return _tokenBaseURI;
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }
}

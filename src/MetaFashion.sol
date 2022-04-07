// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/security/Pausable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import "../lib/ERC721A/contracts/ERC721A.sol";

error TestError();
error VIPMintInactive();
error NotVIP();
error TransactionMintLimitExceeded();
error TransactionLimitExceeded();
error MintingPaused();

contract MetaFashion is ERC721A, Pausable, Ownable {

    enum ContractStatus {
        Paused,
        VIPOnly,
        Public
    }

    // state variables

    /// @notice The maximum number of mints per transaction.
    uint8 constant PUBLIC_MAX_MINT = 5;
    uint8 constant PUBLIC_MAX_TRANSACTIONS = 3;
    uint256 constant PUBLIC_PRICE = 0.085 ether;
    uint8 constant VIP_MAX_MINT = 3;
    uint8 constant VIP_MAX_TRANSACTIONS = 1;
    uint256 constant VIP_PRICE = 0.075 ether;

    string baseURI;
    ContractStatus private status = ContractStatus.Paused;
    bytes32 _vipMerkleRoot;

    // events

    // modifiers
    modifier whenVIP() {
        // TODO
        if (status != ContractStatus.VIPOnly) revert VIPMintInactive();
        _;
    }

    // constructor

    constructor(bytes32 vipMerkleRoot) ERC721A("MetaFashion", "MFHQ") {

        _vipMerkleRoot = vipMerkleRoot;
        pause(); // Pause until explicitly enabled
    }

    // external

    function vipMint(uint8 quantity, bytes32[] calldata proof) external payable whenNotPaused whenVIP {
        if (quantity > VIP_MAX_MINT) revert TransactionMintLimitExceeded();
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

        _safeMint(_msgSender(), quantity);
    }

    function publicMint(uint8 quantity) external payable whenNotPaused {
        if (quantity > PUBLIC_MAX_MINT) revert TransactionMintLimitExceeded();
        // Check public transaction limit
        uint64 transactions = _getAux(_msgSender()) + 1;
        if (transactions > PUBLIC_MAX_TRANSACTIONS)
            revert TransactionLimitExceeded();

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
        baseURI = uri;
    }

    function setContractStatus(ContractStatus contractStatus) public onlyOwner {
        status = contractStatus;
    }

    // internal

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⡀⣀⣀⣀⡀⢀⣀⣀⣀⣀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⡀⠀⢰⣿⣿⣿⣇⣀⣀⣀⣀⣀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡟⠙⣿⣿⡿⠋⢻⣿⣿⣿⡇⢀⣿⣿⣿⣿⠋⢻⣿⣿⣿⣿⠀⣿⣿⣿⣿⠛⠛⠛⠛⠛⠛⠀⣰⣿⣿⣿⠟⠙⣿⣿⣿⣿⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠀⢠⣿⣿⡇⠀⣾⣿⣿⣿⠁⣸⣿⣿⣿⣷⡤⣾⣿⡿⠿⠃⢰⣿⣿⣿⡟⠀⠀⠰⡾⠆⠀⠀⣀⣤⣤⣤⣤⣴⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⡏⠀⣸⣿⣿⠀⢠⣿⣿⣿⡟⠀⣿⣿⣿⣿⠁⢀⣤⣤⣤⣤⠀⣾⣿⣿⣿⠇⠀⣤⣤⣤⣤⠄⣼⣿⣿⣿⡇⠀⣾⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠾⠿⠿⠿⠁⠀⠛⠛⠃⠀⠸⠿⠿⠿⠃⠈⠻⠿⠿⠿⠷⣿⣿⣿⣿⡏⠀⠻⠿⠿⠿⠦⠀⠿⠿⠿⠟⠀⠻⠿⠿⠿⠷⠾⠿⠿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⢀⣶⣿⣿⣿⡿⠿⠿⠂⣴⣿⣿⣿⠟⢿⣿⣿⣿⣦⠀⣴⣿⣿⣿⠟⢿⣿⣿⣿⡦⠀⣿⣿⣿⣿⠟⢿⣿⣿⣿⣷⠀⣼⣿⣿⣿⡇⢠⣾⣿⣿⣿⠟⢿⣿⣿⣿⡆⠀⣾⣿⣿⣿⠞⢿⣿⣿⣿⣷
// ⠀⢸⣿⣿⣿⣿⣤⣤⠀⠀⢉⣉⣉⣁⣀⣼⣿⣿⣿⡇⠘⢿⣿⣿⣯⣄⣘⡛⠛⠛⠁⢸⣿⣿⣿⡏⠀⢸⣿⣿⣿⡏⢀⣿⣿⣿⣿⠀⣼⣿⣿⣿⠇⠀⣾⣿⣿⣿⠇⢸⣿⣿⣿⡟⠀⢸⣿⣿⣿⡏
// ⠀⣿⣿⣿⣿⠉⠉⠁⠀⣾⣿⣿⣿⠉⢉⣿⣿⣿⣿⠀⣠⣤⣤⣭⠉⢻⣿⣿⣿⣦⠀⣿⣿⣿⣿⠃⠀⣿⣿⣿⣿⠁⣸⣿⣿⣿⡇⢠⣿⣿⣿⣿⠀⢠⣿⣿⣿⡿⠀⣿⣿⣿⣿⠃⠀⣿⣿⣿⣿⠁
// ⢸⣿⣿⣿⡟⠀⡀⠀⠸⣿⣿⣿⣿⣦⣾⣿⣿⡿⠏⠐⢿⣿⣿⣿⣦⣾⣿⣿⡿⠇⢰⣿⣿⣿⡟⠀⢸⣿⣿⣿⡟⠀⣿⣿⣿⣿⠁⠸⣿⣿⣿⣷⣤⣾⣿⣿⡿⠃⢰⣿⣿⣿⡿⠀⢸⣿⣿⣿⡟⠀
// ⣾⣿⣿⣿⠃⢰⣿⣦⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⠀⠀


import "ERC721A/ERC721A.sol";
import "ERC721A/extensions/ERC721ABurnable.sol";
import "ERC721A/extensions/ERC721APausable.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

error IncorrectValue();
error MintingPaused();
error NotVIP();
error PublicMintInactive();
error InsufficientSupply();
error TransactionMintLimitExceeded();
error TransactionLimitExceeded();
error VIPMintInactive();


contract MetaFashion is ERC721A, ERC721ABurnable, ERC721APausable, Ownable {

    enum Phase {
        None,
        VIP,
        Public
    }

    // state variables

    /// @notice The total collection size.
    uint256 private constant _COLLECTION_SIZE = 10000;
    /// @notice The maximum number of public mints per transaction.
    uint256 private constant _PUBLIC_MAX_MINT = 5;
    /// @notice The maximum number of public transactions per address.
    uint256 private constant _PUBLIC_MAX_TRANSACTIONS = 3;
    /// @notice The public mint price.
    uint256 private constant _PUBLIC_PRICE = 0.085 ether;
    /// @notice The maximum number of VIP mints.
    uint256 private constant _VIP_MAX_MINT = 3;
    /// @notice The VIP mint price.
    uint256 private constant _VIP_PRICE = 0.075 ether;

    bytes32 private _vipMerkleRoot;
    Phase private _phase = Phase.None;
    string private _tokenBaseURI;

    
    // events

    // modifiers
    modifier whenVIP() {
        if (_phase != Phase.VIP) revert VIPMintInactive();
        _;
    }

    modifier whenPublic() {
        if (_phase != Phase.Public) revert PublicMintInactive();
        _;
    }

    modifier whenQuantityWithinMintLimit(uint256 quantity, uint256 maxMint) {
        if (quantity > maxMint) revert TransactionMintLimitExceeded();
        _;
    }

    modifier whenCorrectValueSent(uint256 quantity, uint256 price) {
        if (msg.value != quantity * price) revert IncorrectValue();
        _;
    }

    modifier whenSufficientSupply(uint256 quantity) {
        if (_totalMinted() + quantity > _COLLECTION_SIZE) revert InsufficientSupply();
        _;
    }

    // constructor

    constructor(bytes32 vipMerkleRoot) ERC721A("MetaFashion", "MFHQ") {
        _vipMerkleRoot = vipMerkleRoot;
        pause(); // Pause until explicitly enabled
    }

    // external

    function vipMint(uint256 quantity, bytes32[] calldata proof) 
        external 
        payable 
        whenNotPaused
        whenVIP
        whenQuantityWithinMintLimit(quantity, _VIP_MAX_MINT)
        whenCorrectValueSent(quantity, _VIP_PRICE)
        whenSufficientSupply(quantity) 
    {
        // Validate VIP eligibility
        if (!MerkleProof.verify(
            proof,
            _vipMerkleRoot,
            keccak256(abi.encodePacked(_msgSender()))
        )) revert NotVIP();

        // VIP mint limited to a single transaction, so check if any minted
        uint256 minted = _numberMinted(_msgSender());
        if (minted > 0) revert TransactionLimitExceeded();

        // Safe minting is reentrant safe and doubles as an gas-optimized reentrancy guard since V3
        // https://chiru-labs.github.io/ERC721A/#/erc721a?id=_mint
        _safeMint(_msgSender(), quantity);
    }

    function publicMint(uint8 quantity) 
        external 
        payable 
        whenNotPaused
        whenPublic
        whenQuantityWithinMintLimit(quantity, _PUBLIC_MAX_MINT)
        whenCorrectValueSent(quantity, _PUBLIC_PRICE)
        whenSufficientSupply(quantity) 
    {
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

    function setPhase(Phase phase) public onlyOwner {
        _phase = phase;
    }

    function setVIPMerkleRoot(bytes32 merkleRoot) public onlyOwner {
        _vipMerkleRoot = merkleRoot;
    }

    function withdraw() public onlyOwner {
        // todo
    }

    // internal

    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal virtual override(ERC721A, ERC721APausable) {
        super._beforeTokenTransfers(from, to, startTokenId, quantity);
    }

    function _baseURI() internal view override returns (string memory) {
        return _tokenBaseURI;
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }
}

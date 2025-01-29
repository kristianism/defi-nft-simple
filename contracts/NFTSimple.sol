//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// This is a simple NFT contract that has the basic mint function.
contract NFTSimple is ERC721, ReentrancyGuard, Ownable, Pausable {
    using SafeERC20 for IERC20; // To use the SafeERC20 library for ERC20 token transfers.

    // Contract variables.
    string private baseURI; // Base Uniform Resource Identifier (URI) for the NFT collection.
    uint256 private nextTokenId; // Token ID Counter for automated minting.
    uint256 public mintPrice; // Mint price for the collection.

    // Events for listeners.
    event MintPriceUpdated (uint256 previousPrice, uint256 newPrice);

    // Constructor arguments for the NFTSimple contract.
    // Ability to determine the name and symbol of the NFT collection.
    constructor (

        string memory _name, // Full name of the NFT collection.
        string memory _symbol, // Short name of the NFT Collection.
        string memory _newURI, // Base metadata for the NFT Collection.
        uint256 _mintPrice  // Mint price that you will set for the collection.

    ) ERC721(_name, _symbol) Ownable(msg.sender) {
        
        baseURI = _newURI;
        mintPrice = _mintPrice;

        emit MintPriceUpdated(0, mintPrice);
    }

    // External function that allows minting of the NFT.
    function mintNFT() external payable nonReentrant whenNotPaused() {
        require(msg.value == mintPrice, "Payable amount is invalid.");

        _safeMint(msg.sender, nextTokenId);
        nextTokenId++;
    }

    // External privileged function to update the base URI of the project.
    // Can only be updated when the contract is paused.
    function setBaseURI(string memory _newURI) external onlyOwner whenPaused() {

        baseURI = _newURI;
    }

    // External privileged function to update the minting price of the NFT collection.
    // Can only be updated when the contract is paused.
    function setMintPrice(uint256 _mintPrice) external onlyOwner whenPaused() {

        uint256 previousPrice = mintPrice; // This records the mint price before updating for use in the event.
        mintPrice = _mintPrice; // Updates the mint price to the new one.
        
        emit MintPriceUpdated(previousPrice, mintPrice);
    }

    // External privileged function to pause the contract for troubleshooting.
    function pause() external onlyOwner {
        _pause();
    }

    // External privileged function to resume the contract's operations.
    function unpause() external onlyOwner {
        _unpause();
    }

    // External privileged function to collect royalties from the contract.
    function collectFees() external onlyOwner {
        uint256 balance = address(this).balance;

        (bool success,) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
    }

    // External privileged function to transfer out tokens sent to the contract inadvertently.
    function collectTokens(IERC20 _tokenAddress, address _to) external onlyOwner {
        uint256 balance = _tokenAddress.balanceOf(address(this));
        
        _tokenAddress.safeTransferFrom(address(this), _to, balance);
    }

    // Internal function to override the base URI function of the inherited contract.
    function _baseURI() internal view virtual override returns (string memory) {
        
        return baseURI;
    }

    // This line allows the contract to receive ether. Optional.
    receive() external payable {}

    /* Contracts by: Kristian
     * Any issues and/or suggestions, you may reach me via:
     * Github: https://github.com/kristianism,
     * X (Twitter): https://x.com/defimagnate
    */

}
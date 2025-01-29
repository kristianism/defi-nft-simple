## Simple ERC721 Non-Fungible Token

Simple NFT contract that has the basic mint function, ownable, and pausable for troubleshooting.

### Solidity Version:
- 0.8.20

### Imports:
- @openzeppelin/contracts/token/ERC721/ERC721.sol
- @openzeppelin/contracts/token/ERC20/IERC20.sol
- @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
- @openzeppelin/contracts/utils/ReentrancyGuard.sol
- @openzeppelin/contracts/utils/Pausable.sol
- @openzeppelin/contracts/access/Ownable.sol

### Constructor Arguments:
- _name: Full name of the NFT collection
- _symbol: Short name of the NFT Collection
- _newURI: Base metadata for the NFT Collection
- _mintPrice: Mint price that you will set for the collection

### Functions:
- mintNFT: External function that allows minting of the NFT at a set mint price
- setBaseURI: External privileged function that allows updating of the NFT metadata in case of server issues
- setMintPrice: External privileged function that allows updating of the minting price per NFT
- pause: External privileged function to pause the contract for troubleshooting
- unpause: External privileged function to resume the contract's operations
- collectFees: External privileged function to collect royalties from the contract
- collectTokens: External privileged function to transfer out tokens sent to the contract inadvertently
- _baseURI: Internal function to override the base URI function of the inherited contract
- OpenZeppelin's default Ownable functions
- OpenZeppelin's default ERC721 functions

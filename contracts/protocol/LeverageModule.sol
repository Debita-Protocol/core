// pragma solidity ^0.8.4; 
// //https://github.com/poap-xyz/poap-contracts/tree/master/contracts
// import {ERC721} from "solmate/tokens/ERC721.sol";
// import {Controller} from "./controller.sol";
// import "forge-std/console.sol";
// import {Vault} from "../vaults/vault.sol";
// import {FixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";


// /// @notice borrow from leverageVault to leverage mint vaults
// contract LeverageModule is ERC721{
//   	using FixedPointMathLib for uint256;

// 	Vault leverageVault; 
// 	address UNDERLYING; 
// 	uint256 constant precision =1e18; 
// 	/// param leverageVault is where the capital is for borrowing
// 	constructor(
// 		address leverageVault_ad
// 		)ERC721("LeverageVaultPosition", "RAMMLV") {
// 		leverageVault = Vault(leverageVault_ad); 
// 		UNDERLYING = leverageVault.UNDERLYING(); 
// 	}

// 	struct Position{
// 		uint256 suppliedCapital; 
// 		uint256 borrowedCapital; 
// 		uint32 borrowTimeStamp;

// 	}

// 	/// @notice Allow people to borrow from leverageVault and use that to
// 	/// create leveraged Vault positions 
// 	/// @dev Step is 1. borrow to this address, 2. mint vault(invest) to this address
// 	/// 3. mint position nft for the caller 
// 	/// param leverageFactor in WAD is percentage of suppliedCapital 
// 	function mintWithLeverage(
// 		uint256 suppliedCapital, 
// 		uint256 leverageFactor) public {
// 		// 1. borrow to this address,
// 		// 2. mint new vault to this address 
// 		// 3. borrow new vault to this 

// 		leverageVault.requestLoan(leverageFactor.mulWadDown(suppliedCapital)); 
		
// 	}

// 	/// @notice Allows leverage minters to close their positions, and share profit with the 
// 	/// leverageVault
// 	function withdrawLeverage() public{

// 	}



// }

// contract ReputationNFT is ERC721 {
//   mapping(uint256 => ReputationData) internal _reputation; // id to reputation
//   mapping(address => uint256) internal _ownerToId;
//   mapping(uint256 => TraderData[]) internal _marketData; // **MarketId to Market's data needed for calculating brier score.

//   uint256 private nonce = 1;
//   Controller controller;
//   uint256 SCALE = 1e18;


//   struct ReputationData {
//     uint256 n; // number of markets participated in => regular uint256
//     uint256 score; 
//   }

//   struct TraderData { // for each market
//     address trader;
//     uint256 tokensBought;
//   }

//   struct TopReputation{
//     address trader; 
//     uint256 score; 
//   }

//   uint256 private constant topRep = 100; 
//   TopReputation[topRep] topReputations; 

//   mapping(uint256=>mapping(address=>bool)) canTrade; //marketID-> address-> cantrade
//   mapping(uint256=>bool) allowAll; 
//   mapping(address=>bool) isUnique; 
//   address[] unique_traders; 
//   mapping(uint256=>mapping(address=>uint256)) public balances; // marketId => market manager address => how much collateral already bought.

//   modifier onlyController() {
//     require(msg.sender == address(controller));
//     _;
//   }

//   constructor (
//     address _controller
//   ) ERC721("Debita Reputation Token", "DRT") {
//     controller = Controller(_controller);
//   }

//   /**
//    @notice incrementBalance
//    */
//   function incrementBalance(uint256 marketId, address trader, uint256 amount) external onlyController {
//     balances[marketId][trader] += amount;
//   }

//   /**
//    @notice called post reputation update
//    */
//   function removeBalance(uint256 marketId, address trader) external onlyController {
//     delete balances[marketId][trader];
//   }

//   function _baseURI() internal pure returns (string memory baseURI) {
//     baseURI = "";
//   }

//   function tokenURI(uint256 id) public view override returns (string memory) {
//     require(_ownerOf[id] != address(0), "Invalid Identifier");

//     string memory baseURI = _baseURI();
//     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, id)) : "";
//   }

//   function mint(address to) external {
//     require(_ownerToId[to] == uint256(0), "can only mint one reputation token");
//     super._mint(to, nonce);
//     _ownerToId[to] = nonce;

//     // Set default score, if this goes to 0 cannot trade
//     _reputation[_ownerToId[to]].score = 1e18; 

//     nonce++;
//   }

//   function getReputationScore(address owner) view external returns (uint256){
//     require(_ownerToId[owner] != uint256(0), "No Id found");
//     return _reputation[_ownerToId[owner]].score;
//   }

//   function setReputationScore(address owner, uint256 score) external returns (uint256) 
//   //onlyOwner
//   {
//     require(_ownerToId[owner] != uint256(0), "No Id found");
//     return _reputation[_ownerToId[owner]].score = score;
//   }


//   function updateScore(address to, int256 score) external onlyController{
//     require(_ownerToId[to] != uint256(0), "No Id found");

//     ReputationData storage data = _reputation[_ownerToId[to]];
//     if (score > 0) data.score = data.score + uint256(score);
//     else{
//         if (data.score <= uint256(-score)) data.score = 0; 
//         else data.score = data.score - uint256(-score);
//       } 

//     storeTopX(data.score, to); 
//   }


//   function addScore(address to, uint256 score) external onlyController
//    {
//     require(_ownerToId[to] != uint256(0), "No Id found");

//     ReputationData storage data = _reputation[_ownerToId[to]];
//     data.score = data.score + score; 

//     storeTopX(data.score, to); 
//   }

//   function decrementScore(address to, uint256 score) external onlyController
//    {
//     require(_ownerToId[to] != uint256(0), "No Id found");

//     ReputationData storage data = _reputation[_ownerToId[to]];
//     if (data.score <= score) data.score = 0; 
//     else data.score = data.score - score; 

//     storeTopX(data.score, to); 
//   }

//   function addAverageScore(address to, uint256 score) external onlyController

//    {
//     require(_ownerToId[to] != uint256(0), "No Id found");

//     ReputationData storage data = _reputation[_ownerToId[to]];
    
//     if (data.n == 0) {
//       data.score = score;
//     } else {
//       data.score = (data.score / data.n + score) / (data.n + 1);
//     }

//     data.n++;
//   }

//   /**
//    @notice reset scores
//    */
//   function resetScore(address to) external {
//     require(_ownerToId[to] != uint256(0), "No Id found");
//     delete _reputation[_ownerToId[to]];
//   }

//   /// @notice called by controller when initiating market,
//   function storeTopReputation(uint256 topX, uint256 marketId) external onlyController{
//     if (getAvailableTopX() < topX) {
//       allowAll[marketId] =true; 
//       return; 
//     }

//     for (uint256 i; i<topX; i++){
//       canTrade[marketId][topReputations[i].trader] = true;
//     }

//   }

//   /// @notice gets the x's ranked score from all reputation scores 
//   /// @dev returns 0 if topX is greater then avaiable nonzero rep scores-> everyone is allowed
//   /// during reputation constraint periods 
//   function getMinRepScore(uint256 topX) public view returns(uint256) {
//     if (getAvailableTopX() < topX) {
//       return 0; 
//     }
//     return topReputations[topX].score;
//   }

//   function getAvailableTopX() public view returns(uint256){
//     return unique_traders.length; 
//   }

//   function getAvailableTraderNum() public view returns(uint256){
//     return nonce -1; 
//   }

//   /// @notice whether trader is above reputation threshold 
//   function traderCanTrade(uint256 marketId, address trader) external returns(bool){
//     return allowAll[marketId]? true : canTrade[marketId][trader]; 
//   }

//   /// @notice called whenever a score is incremented   
//   function storeTopX(uint256 score, address trader) internal {
//     uint256 i = 0;

//     for(i; i < topReputations.length; i++) {
//       if(topReputations[i].score < score) {
//         break;
//       }
//     }
//     // shifting the array of position (getting rid of the last element) 
//     for(uint j = topReputations.length - 1; j > i; j--) {
//         topReputations[j].score = topReputations[j - 1].score;
//         topReputations[j].trader = topReputations[j - 1].trader;
//     }
//     // update the new max element 
//     topReputations[i].score = score;
//     topReputations[i].trader = trader;

//     if (isUnique[trader]) return; 
//     isUnique[trader] = true; 
//     unique_traders.push(trader);

//   }

//   function testStore() public view {
//     for (uint i=0; i<10; i++){
//       console.log('score', topReputations[i].score); 
//     }
//   }  
// }
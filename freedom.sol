// This currency shall foster freedom, fairness, peace and love   
// This currency shall help to free people who have been unlawfully framed and imprisoned    

// I write the following code in a way that everyone shall be able to understand it     
// Please share your feedback regarding security, readability, performance, low gas fees and tokenomics with the CULT community     
// Please always make sure you are connected with the right blockchain and that you interact with the right smart contract     
// Claim your rewards regularly - see claimCurrentlyAvailableLiquidityBackedMaxRewards
// Please do not trust anyone specifically too much especially if they pretend to be me the developer of this smart contract     
// If you want to trust anyone in the crypto space I recommend to do so only if they have 1. skin in the game and 2. a several years long track record of doing & supporting the right things   


// SPDX-License-Identifier: GNU GPL v3
pragma solidity 0.8.2; 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Freedom is ERC20 {

    uint256 public fixedSupply = 21000000; // There is a fixed supply of 21.000.000 Coins

    struct FreedomFan {
        address walletAddress;
        string proofLink;
        uint256 appliedOn;
        uint256 approvedOn;
        uint256 amountOfReceivedApprovals;
    }

    mapping(address => uint256) public ids; 
    mapping(uint256 => FreedomFan) public freedomFans; 
    mapping(address => address[]) public approversForFreedomFan; 
    mapping(address => uint256) public ethLiquidityProviders;  
    mapping(address => uint256) public maxRewardPerApprover;  

    
    uint256 public numberOfFreedomFans = 1; 
    uint256 public numberOfApprovedFreedomFans = 0;
    uint256 public currentThresholdForBecomingFullyApproved = 1;
    
    bool public developerApproved = false; // will be set to true as soon as the developer is approved via the startProject function.

    event LOGMessage(string);
    
    constructor() ERC20("Freedom", "FREE") {
        // with the following all 21.000.000 coins are transferred to this contract itself.
        _mint(address(this), fixedSupply * (10 ** decimals())); 
    }

    // The following modifiers are executed as checks before specific functions (see then further below) to protect the correct flow
    modifier avoidDuplicateApprovals(address freedomFan) { 
        for (uint256 i = 0; i < approversForFreedomFan[freedomFan].length; i++) {
            require(approversForFreedomFan[freedomFan][i] != msg.sender, "we avoid duplicate approvals from one approver for one freedom fan");
        }   
        _; 
    }
    modifier onlyNotYetApprovedFreedomFansCanBeApproved(address freedomFan) {
        require(freedomFans[ids[freedomFan]].approvedOn == 0, "only not yet approved freedom fans can be approved");
        _;
    }
    modifier onlyApprovedHolders() {
        require((freedomFans[ids[msg.sender]].approvedOn > 0 && balanceOf(msg.sender) > 0), "only approved holders can do that");
        _;
    }
    

    // Freedom Fans can join by sending a prooflink to proof they love freedom, fairness & peace
    function joinFreedomFans(string memory proofLink) external {
        require(ids[msg.sender] == 0, "it seems this wallet already applied once.");
        numberOfFreedomFans = numberOfFreedomFans + 1;
        ids[msg.sender] = numberOfFreedomFans;
        freedomFans[numberOfFreedomFans].walletAddress = msg.sender;
        freedomFans[numberOfFreedomFans].proofLink = proofLink;
        freedomFans[numberOfFreedomFans].appliedOn = block.timestamp;
        freedomFans[numberOfFreedomFans].approvedOn = 0; // not yet approved
        freedomFans[numberOfFreedomFans].amountOfReceivedApprovals = 0; 
    }

    // As soon as a new Freedom Fan is fully approved, he and his approvers are eligible to receive a reward until all Coins are distributed
    function approveFreedomFan(address freedomFan) public avoidDuplicateApprovals(freedomFan) onlyApprovedHolders onlyNotYetApprovedFreedomFansCanBeApproved(freedomFan) {
        freedomFans[ids[freedomFan]].amountOfReceivedApprovals++; 
        if (freedomFans[ids[freedomFan]].amountOfReceivedApprovals >= currentThresholdForBecomingFullyApproved) {
            freedomFans[ids[freedomFan]].approvedOn = block.timestamp;
            if (balanceOf(address(this)) >= (1 * (10 ** 18))) {
                maxRewardPerApprover[freedomFan] = 24 * (10 ** decimals()); // welcome gift to new freedom fan
            } else {
                emit LOGMessage("the fixed supply of overall 21.000.000 Coins / the balanceOf FREE of this contract does not allow welcome gifts atm. new approved freedom fans might invest in FREE via the buy function.");
            }

            for (uint i = 0; i < approversForFreedomFan[freedomFan].length; i++) {
                if (balanceOf(address(this)) >= (1 * (10 ** 18))){
                        maxRewardPerApprover[approversForFreedomFan[freedomFan][i]] = maxRewardPerApprover[approversForFreedomFan[freedomFan][i]] + 1 * (10 ** decimals());
                } else {
                    emit LOGMessage("the fixed supply of overall 21.000.000 Coins / the balanceOf FREE does not allow direct rewards for approvers atm. the incentives should anyways be high enough to continue approving wisely.");
                }
            }
            if ((currentThresholdForBecomingFullyApproved % 2) == 0){ 
                currentThresholdForBecomingFullyApproved++; 
            }
        }
    }

    function claimCurrentlyAvailableLiquidityBackedMaxRewards() public {
        if (balanceOf(address(this)) >= maxRewardPerApprover[msg.sender]) {
            this.transfer(msg.sender, maxRewardPerApprover[msg.sender]);
        } else {
            this.transfer(msg.sender, balanceOf(address(this)));
        }
    }

    function startProject() public { 
        address developerWallet = 0x9E972a43B3B8D68cD70930697E16429E47E88151; 
        require(developerApproved == false && msg.sender == developerWallet, "startProject can only be executed once to start this project in a clear and fair way");
        ids[msg.sender] = numberOfFreedomFans;
        freedomFans[numberOfFreedomFans].walletAddress = msg.sender;
        freedomFans[numberOfFreedomFans].proofLink = "https://twitter.com/Peer2peerE/status/1695323724646322412";
        freedomFans[numberOfFreedomFans].appliedOn = block.timestamp;
        freedomFans[numberOfFreedomFans].approvedOn = block.timestamp; // not yet approved
        freedomFans[numberOfFreedomFans].amountOfReceivedApprovals = 1; 
        approversForFreedomFan[msg.sender].push(address(this)); 
        numberOfApprovedFreedomFans = 1;
        this.transfer(msg.sender, 24 * (10 ** decimals()));
        developerApproved = true;
    }

   
    // buy and sell here is designed to:  
    // 1. be free from rather limiting dependencies and fees from liquidity pools, cexes and dexes      
    // 2. restrict max buying amount per holder to 1 Finney to support long term decentralization & fairness    
    // 3. ensure the price is defined by the network size and by the value of the network   
    function buy() public payable onlyApprovedHolders { 
        require(msg.value <= 1 * 10 ** 15, "you can buy for a maximum of one finney which is 0.001 ETH. chancellor on brink of second bailout for banks :)"); // this is meant to foster decentralization 
        require(msg.value + ethLiquidityProviders[msg.sender] <=  1 * 10 ** 15, "you can overall buy for a maximum of one finney which is 0.001 ETH it seems you invested already earlier");
        uint256 priceOfOneFREEInWEI = numberOfApprovedFreedomFans * (10**18) / 1000000000; // the more approved freedom fans there are, the higher the value of FREE
        uint256 amountToBeTransferred = (msg.value / priceOfOneFREEInWEI) * (10**18);
        require(balanceOf(address(this)) >= amountToBeTransferred, "you cannot buy that many at the moment via this function. buy from your neighbor if possible.");
        this.transfer(msg.sender, amountToBeTransferred); 
    }

    function sell(uint256 amountInWEI) external  onlyApprovedHolders {
        require(balanceOf(msg.sender) >= amountInWEI, "this smart contract does not support selling more than you have.");    
        require(allowance(msg.sender, address(this)) >= amountInWEI, "please set an appropriate allowance first.");    
        IERC20(address(this)).transferFrom(msg.sender, address(this), amountInWEI); 
        uint256 amountInWEIToBeSent = 1000000000 / numberOfApprovedFreedomFans;
        require(address(this).balance >= amountInWEIToBeSent, "this smart contract does not have enough ETH liquidity available for this deal atm.");
        payable(msg.sender).transfer(amountInWEIToBeSent);
    }

}

// The blockchain technology as distributed ledger technology will gain appreciation even further once people appreciate their neighbours and everyone who loves freedom, fairness and peace even more imo.  
// fun facts: https://github.com/michael-spengler/distributed-ledger-technology-hands-on-lecture/blob/main/fun-facts/bitcoin-related-fun-facts.md  

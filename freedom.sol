// This Smart Contract defines the cryptocurrency named Freedom (FREE)   
// The goal of this project is to serve as a tool for freedom, fairness, peace and love    
// This project shall inspire people to explore sufficiently decentralized crypto currencies and the corresponding concepts & technologies  
// This project is inspired by the https://cultdao.io & by the https://cultmagazine.org (2022 & 2023)  
// Please use self hosted wallets (at the moment https://metamask.io seems the best - still waiting for https://twitter.com/web3d3v wallet)      
// Please make sure to use the right smart contract address & ensure you are connected with the right network    
// Please make sure you are aware that there are many scammers out there. Do your own research and talk to people who already know more than you about self hosted wallets...   
// This project can also serve as a mirror to be held in front of the people who blindly obey their unfair political regimes after the ones who supported freedom early are already rich and free   


// SPDX-License-Identifier: GNU GPL v3
pragma solidity 0.8.2; 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @custom:security-contact dm to https://twitter.com/Peer2peerE 
contract Freedom is ERC20 {

    struct Member {
        uint256 appliedOn;
        string proofLink;
        uint256 amountOfReceivedApprovals;
        address[] approversForThisMember;
        uint256 approvedOn;
    }
    
    mapping(address => Member) public members;

    uint256 public totalAmountOfApprovedMembers = 0;
    uint256 public threshold = 1;

    bool contractInitializationCompleted = false; 

    event MembershipApproved(address addressOfNewlyApprovedMember);

    event MembershipNeedsMoreApprovals(address addressOfProspect, uint256 amountOfApprovalsReceived, uint256 currentThreshold);

    event LOGIT(uint256 myText);


    constructor() ERC20("Freedom", "FREE") {
        uint32 fixedSupply = 24000000;

        _mint(address(this), fixedSupply * (10 ** decimals())); // all 24.000.000 coins to the contract
    }


    modifier onlyApprovedMembers() {
        require(members[msg.sender].approvedOn > 0, "only approved Members can do that");
        _;
    }
    
    modifier onlyNotYetApprovedMembersCanBeApproved(address memberAddress) {
        require(members[memberAddress].approvedOn == 0, "only not yet approved members can be approved");
        _;
    }

    modifier onlyTokenholdersCanApprove {
        require (balanceOf(msg.sender) > 0, "only holders can approve others");
        _;
    }

    modifier onlyExecutedOnce() {
        require(contractInitializationCompleted == false, "this ensures the dev of this smart contract only approves himself once");
        _;
    }

    function applyForMembership(string calldata proofLink) public {
            require(members[msg.sender].appliedOn == 0, "it seems this wallet already applied once.");

            members[msg.sender].appliedOn = block.timestamp;
            members[msg.sender].proofLink = proofLink;
    }

    function approveMembership(address memberAddress) public onlyApprovedMembers onlyNotYetApprovedMembersCanBeApproved(memberAddress) onlyTokenholdersCanApprove {

        require(members[memberAddress].appliedOn > 0, "this prospect seems not to have provided a great prooflink yet.");

        members[memberAddress].amountOfReceivedApprovals++;

        members[memberAddress].approversForThisMember.push(msg.sender);
        if (members[memberAddress].amountOfReceivedApprovals >= threshold) {
            members[memberAddress].approvedOn = block.timestamp;
            if (balanceOf(address(this)) >= 24 * (10 ** 18)){
                this.transfer(memberAddress, 24 * (10 ** decimals())); // the welcome gift for everyone until fully distributed
            }
            totalAmountOfApprovedMembers = totalAmountOfApprovedMembers + 1;
            if ((totalAmountOfApprovedMembers % 2) == 0) {
                threshold++;
            }
            emit MembershipApproved(memberAddress);
        } else {
            emit MembershipNeedsMoreApprovals(memberAddress, members[memberAddress].amountOfReceivedApprovals, threshold);
        }
    }

    function transferRewardToSuccessfulApprovers(address newApprovedMember) public {
        for (uint i = 0; i < members[newApprovedMember].approversForThisMember.length; i++) {
            if (balanceOf(address(this)) >= (1 * (10 ** 18))){
                if (balanceOf(members[newApprovedMember].approversForThisMember[i]) < 240 * (10**18)){ // assumption: no one needs more than 240 FREE - decentralization rocks
                    this.transfer(members[newApprovedMember].approversForThisMember[i], 1 * (10 ** decimals())); // approvers reward
                }
            }
        }
    }
    
    
    function approveMembershipOfDeveloper(string calldata proofLink) public onlyExecutedOnce {
        members[msg.sender].appliedOn = block.timestamp;
        members[msg.sender].proofLink = proofLink; 
        members[msg.sender].amountOfReceivedApprovals = 1; // by myself to initialize and to stay one of teh many
        members[msg.sender].approvedOn = block.timestamp;
        this.transfer(msg.sender, 24 * (10 ** decimals())); // the welcome gift for everyone until fully distributed
        totalAmountOfApprovedMembers = totalAmountOfApprovedMembers + 1; // shall be 1 then
        contractInitializationCompleted = true; // so this function can not be executed once again
        emit MembershipApproved(msg.sender);
    }

    function getMember(address memberAddress) public view returns(Member memory) {
        return members[memberAddress];
    }


    function buyFreedom() public payable onlyApprovedMembers { 
        uint256 conversionRate = 0;
        if (totalAmountOfApprovedMembers < 1000000 && totalAmountOfApprovedMembers >= 0) {
            conversionRate = 1000000 - totalAmountOfApprovedMembers;
        } else {
            conversionRate = 1;
        }

        uint256 amountOfEtherReceived = msg.value;
        uint256 amountOfFreedomToBeSent = amountOfEtherReceived * conversionRate;
        
        require((balanceOf(msg.sender) + amountOfFreedomToBeSent) <= 240 * (10**18), "assumption: no one needs more than 240 FREE - decentralization rocks");

        this.transfer(msg.sender, amountOfFreedomToBeSent); 
    }


    function sellFreedom(uint256 amount) external onlyApprovedMembers {
        require(allowance(msg.sender, address(this)) >= amount, "set allowance first");
        require(amount >= (0.001 * (10 **18)), "you might send a higher amount to avoid arithmetic challenges");
        uint256 conversionRate = 0;
        if (totalAmountOfApprovedMembers < 1000000) {
            conversionRate = 1000000 - totalAmountOfApprovedMembers;
        } else {
            conversionRate = 1;
        }
    
        uint256 amountOfEtherINWEIToBeSent = amount / conversionRate;
        require(address(this).balance >= amountOfEtherINWEIToBeSent, "Not enough ETH liquidity available for this deal atm.");

        IERC20(address(this)).transferFrom(msg.sender, address(this), amount);


        emit LOGIT(amountOfEtherINWEIToBeSent);
        payable(msg.sender).transfer(amountOfEtherINWEIToBeSent);

    }

    function getEtherBalanceOfSmartContract() public view returns(uint256) {
        return address(this).balance;
    }


        // function investInDAO(address smartContractAddressOfDAOToBeInvestedIn) public onlyTop1000Holders {
        // might be implemented and deployed when modulus mainnet is available 
        // instead of ETH we would use CULT on modulus
        // combine long-, mid-, and short- term bollinger bands - see also https://deno.land/x/bollinger_bands
        // the following is just pseudo code which might serve as a reminder or inspiration
        // struct DAOToBeInvestedIn {
        //    address smartContractAddressOfDAOToBeInvestedIn; // resp. CULT on Modulus
        //    uint256 numberOfUpvotes;
        //    uint256 numberOfDownvotes;
        //    }
        // uint256 thresholdForDAOToBeInvestedInDecision;
        // uint256 thresholdForRemovingDAOFromFurtherInvestments;
        // }

}

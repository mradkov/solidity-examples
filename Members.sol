pragma solidity ^0.4.19;

// Create a contract, that:
//  Is Owned
//  Can be killed
//  Uses safe math operations
//  Has members (people that are member of the contract)
//  The owner is the first member
//  The owner can remove members
//  To add a new member, there needs to be a voting
//      If >50% of the members agree, the new member is added
//  For each member we hold:
//      His address
//      ETH donated to the contract
//      Timestamp of last donation
//      Value of last ETH donation
//  A member can be removed from the contract if he hasn’t donated to the contract in the last 1 hour
//  Use a library for all member related actions
//  Bonus if you don’t use any arrays or loops :)
//  BONUS:
//      Each member can propose another member, when voting starts.
//      Only one voting can be active at a time, but you can make unlimited active votes for bonus points
//      The owner cannot be removed as member
//      Members cannot be removed while voting is active,
//           NOT by the onwer NOR by the automatic removal if no donations in the past hour.
//      Library for the member structure and functions (e.g. member erasing, mebmer update after donate ... etc)
//      Livrary for voting-related actions.

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

library MemberActions {
    using SafeMath for uint256;
    
    struct MemberData {
        bool isMember;
        bool voted;
        uint256 totalDonations;
        uint256 lastDonationAmount;
        uint256 lastDonationTimeStamp;
    }
    
    struct MembersData { mapping(address => MemberData) membersData; }
    
    function addMember(MembersData storage self, address _address) internal {
        self.membersData[_address].isMember = true;
    }

    function removeMember(MembersData storage self, address _address) internal {
        self.membersData[_address].isMember = false;
    }

    function voteExpressed(MembersData storage self, address _address) internal {
        self.membersData[_address].voted = true;
    }

    function voteReseted(MembersData storage self, address _address) internal {
        self.membersData[_address].voted = false;
    }

    function setTotalDonations(MembersData storage self, address _address, uint256 _lastDonation) internal {
        self.membersData[_address].totalDonations.add(_lastDonation);
    }
    
    function setLastDonationAmount(MembersData storage self, address _address, uint256 _lastDonation) internal {
        self.membersData[_address].lastDonationAmount = _lastDonation;
    }

    function setLastDonationTimeStamp(MembersData storage self, address _address) internal {
        self.membersData[_address].lastDonationTimeStamp = now;
    }
}


contract Owned {
    address owner;

    event LogOwnershipTransfered(address indexed _currentOwner, address indexed _newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function Owned() public {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        owner = _newOwner;
        LogOwnershipTransfered(msg.sender, _newOwner);
    }
}


contract Members is Owned {

    using MemberActions for MemberActions.MemberData;
    using MemberActions for MemberActions.MembersData;
    using SafeMath for uint256;

    event LogVoteCalledOn(address _address, uint256 _timeStamp);

    MemberActions.MembersData members;
    uint256 allMembers;
    uint256 votedMembers;
    bool voteInProgress = false;
    address voteCaller;

    function Members() public {
        members.addMember(owner);
        allMembers++;
    }

    modifier IsMember() {
        require(members.membersData[msg.sender].isMember == true);
        _;
    }
    
    modifier CanVote() {
        require(members.membersData[msg.sender].voted == false);
        _;
    }
    
    modifier CanCallVote() {
        require(!voteInProgress);
        _;
    }
    
    modifier CanStopVote() {
        require(voteCaller == msg.sender);
        _;
    }

    function callVoteForNewMember(address _address) public IsMember CanCallVote {
        voteCaller = msg.sender;
        voteInProgress = true;
        LogVoteCalledOn(_address, now);
        vote();
        members.voteExpressed(msg.sender);
        votedMembers++;
    }
    
    function vote() public CanVote {
        require(voteInProgress);
        members.voteExpressed(msg.sender);
        votedMembers++;
    }

    function resetVote() public IsMember {
        members.voteReseted(msg.sender);
    }

    function stopVoteForNewMember(address _address) public CanStopVote {
        if (votedMembers > allMembers.div(2)) {
            members.addMember(_address);
            allMembers++;
        }
            
        voteInProgress = false;
        votedMembers = 0;
    }
    
    function donate() public payable IsMember {
        members.setTotalDonations(msg.sender, msg.value);
        members.setLastDonationAmount(msg.sender, msg.value);
        members.setLastDonationTimeStamp(msg.sender);
    }
    
    function removeMemberByOwner(address _member) public onlyOwner {
        require(!voteInProgress);
        members.removeMember(_member);
    }
    
    function removeMemberByMember(address _member) public {
        require(!voteInProgress);
        require(_member != owner);
        require(members.membersData[_member].lastDonationTimeStamp + 1 hours < now);
        members.removeMember(_member);
    }
}

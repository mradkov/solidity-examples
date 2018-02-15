pragma solidity ^0.4.19;

// Write two contracts. 
// The first one must have three functions
// – one that receives ether,
// one that checks the current balance of the contract,
// if called by the owner, and one that transfers
// a specified amount of ether at a specified address.
// The second contract must have two functions
// – one returning the current balance of the contract
// and the other must be payable so that the contract can receive ether. 

contract FallbackFunctionality {
    
    address public owner;

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    function FallbackFunctionality() public {
        owner = msg.sender;
    }

    function getBalance() public isOwner returns(uint) {
        return this.balance;
    }

    function transfer(address _addr, uint _amount) public isOwner {
        assert(_amount <= this.balance);
        _addr.transfer(_amount);
    }

    function deposit() public payable {
        
    }
}


contract RecipientContract {

    address private owner;

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    function RecipientContract() public {
        owner = msg.sender;
    }

    function deposit() public payable {
        
    }

    function getBalance() public isOwner returns(uint) {
        return this.balance;
    }

}
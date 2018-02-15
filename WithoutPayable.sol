pragma solidity ^0.4.19;

// For this exercise, we will need two contracts. 
// The first one will have function that can be called by anyone
// and through which ether is sent to the contract.
// Only the owner will be able to call the second and third functions
// – the one that returns the contract`s balance and one that destroys the contract. 


contract CallableDeposit {

    address private owner;

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    function CallableDeposit() public {
        owner = msg.sender;
    }

    function deposit() public payable {

    }

    function getBalance() public isOwner returns(uint) {
        return this.balance;
    }

    function sendBalance(address _toAddress) public isOwner {
        selfdestruct(_toAddress);
    }

}

contract NoPayable {

    address public owner;

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    function NoPayable() public {
        owner = msg.sender;
    }

    function getBalance() public isOwner view returns(uint) {
        return this.balance;
    }
}
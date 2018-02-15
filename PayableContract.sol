pragma solidity ^0.4.19;

// Write a contract that has a function through which anyone can send it some ether. 
// In addition, only the owner can check the current balance of the contract. 

contract PayableContract {

    address contractOwner;

    function PayableContract() public {
        contractOwner = msg.sender;
    }

    function deposit() public payable {

    }

    function getBalance() public returns(uint) {
        require(msg.sender == contractOwner);
        return this.balance;
    }

}
pragma solidity ^0.4.19;

// Write two contracts of which one
// must contain a function that destroys the contract.
// All other functionality must be inherited.
// Only the owner can terminate the contract
// and receive its balance. Before it is terminated, some ether must be send to its balance. 

contract TerminableContract {
    function terminate() public {
        selfdestruct(msg.sender);
    }
}


contract MainContract {
    
    address internal owner;

    modifier isOwner() {
        require(owner == msg.sender);
        _;
    }

    function MainContract() public {
        owner = msg.sender;
    }

    function deposit() public payable {

    }

    function getBalance() public view returns(uint) {
        return this.balance;
    }

}


contract ToBeTerminated is MainContract {
    function terminate() public isOwner {
        selfdestruct(msg.sender);
    }
}
pragma solidity ^0.4.19;


contract Owned {

    address owner;

    event OwnershipTransfered(address indexed _currentOwner, address indexed _newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function Owned() public {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        owner = _newOwner;
        OwnershipTransfered(msg.sender, _newOwner);
    }
}


contract Remittance is Owned {

    struct PendingTransaction {
        uint amount;
        string passwordFirst;
        string passwordSecond;
    }

    uint exchangeRate = 150;
    address exchangeAddress;
    
    mapping(string => PendingTransaction) transactions;

    modifier isExchange() {
        require(msg.sender == exchangeAddress);
        _;
    }

    function Remittance(address _exchangeAddress) public {
        owner = msg.sender;
        exchangeAddress = _exchangeAddress;
    }

    function sendTransfer(uint amount, string password) public {
        
    }

    function executeTransfer(string password) public isExchange {
        
    }
}
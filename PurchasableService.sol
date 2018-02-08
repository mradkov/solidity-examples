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

contract PurchasableService is Owned {
    
    event Bought(address indexed buyerAddress);
    
    uint serviceCost;
    uint lastBought;
    uint lastWithdrawal;
    
    modifier lastPurchase() {
        require(now - lastBought >= 2 minutes);
        _;
    }
    
    function PurchasableService() public {
        owner = msg.sender;
        serviceCost = 1 ether;
        lastBought = 0;
    }
    
    function() public payable {
        require(msg.value >= 1 ether);
        Bought(msg.sender);
        lastBought = now;
        uint extraMoney = msg.value - serviceCost;
        if(extraMoney > 0) {
            msg.sender.transfer(extraMoney);
        }
    }
    
    function withdraw(uint amount) public onlyOwner {
        require(now - lastWithdrawal >= 1 hours);
        require(amount < 5 ether);
        require(this.balance >= amount);
        owner.transfer(amount);
        lastWithdrawal = now;
    }
    
}
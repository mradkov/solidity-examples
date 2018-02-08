pragma solidity ^0.4.19;

contract Ownership {
    
    address owner;
    
    event TransferOwnership(address indexed from, address indexed to);
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function Ownership () public {
        owner = msg.sender;
    }
    
    function getOwner () public view returns (address) { 
        return owner;
    }
    
    function transferOwnership (address _owner) public onlyOwner {
        owner = _owner;
        TransferOwnership(msg.sender, _owner);
    }
    
}
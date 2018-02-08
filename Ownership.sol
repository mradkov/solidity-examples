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
    
    function transferOwnership (address _owner) public onlyOwner returns (address) {
        owner = _owner;
        TransferOwnership(msg.sender, _owner);
        return owner;
    }
    
}
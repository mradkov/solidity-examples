pragma solidity 0.4.19;


contract Owned {
    address public owner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function Owned() public {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) public onlyOwner returns (bool) {
        owner = _newOwner;
    }
}


contract SimpleToken is Owned {
    
    mapping(address => uint) public balanceOf;
    
    function SimpleToken (uint _initialSupply) public {
        owner = msg.sender;
        balanceOf[msg.sender] = _initialSupply;
    }
    
    function trasfer(address _toAddress, uint _amount) public {
        require(balanceOf[msg.sender] >= _amount);
        require(balanceOf[_toAddress] + _amount >= balanceOf[_toAddress]);
        balanceOf[msg.sender] -= _amount;
        balanceOf[_toAddress] += _amount;
    }
    
}
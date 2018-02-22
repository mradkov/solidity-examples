pragma solidity ^0.4.19;

// Create people balances contract.
// The contract holds the account balance and the balance is represented by an integer (think tokens). The that:
// Has states:
// Crowdsale in the first 5 minutes, where people can buy the token at a rate of 5 Tokens / 1 ETH.
// People cannot transfer during this period
// Open exchange of tokens after that period.
// The contract owner can withdraw the ETH 1 year after the initial sale
// For each token holder there should be a boolean flag that shows if that person holds or ever held tokens
// There should be an array that contains all current or past token holders 
// No duplicates :)

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


contract Crowdsale is Owned {

    using SafeMath for uint;

    string public name = "HACKBG-TOKEN";
    string public symbol = "HACK";
    uint256 public totalSupply = 0;
    uint256 decimals = 8;
    uint public tokenPrice = SafeMath.div(1 ether, 5);
    uint crowdsaleStartTime = block.timestamp;
    uint public crowdsaleCloseTime = block.timestamp + 5 minutes;

    mapping(address => uint) public balanceOf;
    mapping(address => bool) public investorsHistory;
    
    modifier exchangeAllowed() {
        require(now - crowdsaleCloseTime >= 0);
        _;
    }

    modifier crowdsaleAllowed() {
        require(crowdsaleCloseTime > now);
        _;
    }

    modifier withdrawAllowed() {
        require(now > crowdsaleStartTime + 1 years);
        _;
    }

    event LogTokenTransfer(address indexed _from, address indexed _to, uint256 indexed _value);
    event LogTokenBurn(address indexed from, uint256 value);
    event LogTokenMint(address indexed from, uint256 value);

    function Crowdsale() public {

    }

    function transferToken(address _from, address _to, uint256 _value) public exchangeAllowed returns (bool success) {
        _transfer(_from, _to, _value);
        investorsHistory[_to] = true;
        return true;
    }

    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        LogTokenTransfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function mintToken(address _target, uint256 _mintedAmount) internal {
        balanceOf[_target] = balanceOf[_target].add(_mintedAmount);
        totalSupply = totalSupply.add(_mintedAmount);
        LogTokenTransfer(0, this, _mintedAmount);
        LogTokenTransfer(this, _target, _mintedAmount);
        LogTokenMint(_target, _mintedAmount);
    }

    function () public payable crowdsaleAllowed {
        uint amount = msg.value;
        mintToken(msg.sender, amount.div(tokenPrice));
        investorsHistory[msg.sender] = true;
    }

    function withdraw(uint amount) public onlyOwner withdrawAllowed {
        require(this.balance >= amount);
        owner.transfer(amount);
    }
    
}
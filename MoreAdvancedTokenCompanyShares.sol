pragma solidity ^0.4.19;

// Write a contract that creates an initial supply of shares.
// Their price and the amount of dividend must vary.
// Only the contract’s owner must be allowed to allocate additional funds to the contract.
// Furthermore, only the contract’s owner must be able to allow withdrawal of funds.
// In addition, it must be possible only for the contract’s owner to see the addresses of the shareholders.
// Addresses must be allowed to purchase available shares only if they pay the required price.
// Shareholders may withdraw funds only if allowed to.
// Prices and dividends must use different denominations of ether.
// The representation of the denomination must be presented in a user-friendly manner.
// All conditions check must be made through the use of modifiers.

contract MoreAdvancedTokenCompanyShares {
    
    address private owner;
    uint public price;
    uint public divident;
    mapping(address => uint) private sharesPerAddress;
    mapping(address => bool) private addressesAllowedToWithdraw;
    address[] shareholders;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier availableShares(uint amount) {
        require(sharesPerAddress[owner] >= amount);
        _;
    }

    function MoreAdvancedTokenCompanyShares(uint initialSupply, uint pricePerShare, uint _divident) public {
        owner = msg.sender;
        sharesPerAddress[owner] = initialSupply;
        price = pricePerShare * 1 ether;
        divident = _divident * 1 ether;
    }

    function getPricePerShare() public view returns (uint) {
        return price / 1 ether;
    }

    function calculateTransactionWorth(uint amount) public view returns (uint) {
        return (amount * price) / 1 ether;
    }

    function buyShares(uint amount) public payable availableShares(amount) {
        require(sharesPerAddress[msg.sender] + amount >= sharesPerAddress[msg.sender]);
        require(msg.value == amount * price);
        sharesPerAddress[owner] -= amount;
        sharesPerAddress[msg.sender] += amount;
    }

    function addShareholder(address _address) public onlyOwner {
        shareholders.push(_address);
    }

    function getShareholders() public view onlyOwner returns (address[]) {
        return shareholders;
    }

    function allowWithdraw(address _address) public onlyOwner {
        addressesAllowedToWithdraw[_address] = true;
    }

    function depositEarnings() public payable onlyOwner {

    }

    function setDivident(uint _divident) public onlyOwner {
        divident = _divident * 1 ether;
    }

    function setPrice(uint _price) public onlyOwner {
        price = _price * 1 ether;
    }

    function getBalance() public view onlyOwner returns(uint) {
        return this.balance / 1 ether;
    }

    function getNumberOfShares(address _address) public view returns(uint) {
        require(msg.sender == owner || msg.sender == _address);
        return sharesPerAddress[_address];
    }

    function withdraw() public {
        require(sharesPerAddress[msg.sender] > 0);
        require(this.balance >= sharesPerAddress[msg.sender] * divident);
        require(addressesAllowedToWithdraw[msg.sender] == true);
        addressesAllowedToWithdraw[msg.sender] = false;
        msg.sender.transfer(sharesPerAddress[msg.sender] * divident);
    }

}
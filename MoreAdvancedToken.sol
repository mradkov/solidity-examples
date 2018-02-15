pragma solidity ^0.4.19;

// Write a contract that creates an initial supply of shares,
// their price and the dividend that will be paid.
// In addition, only the contract’s owner must be allowed
// to allocate additional funds to the contract.
// Furthermore, only the contract’s owner must be able
// to allow withdrawal of funds. In addition, it must be possible
// only for the contract’s owner to see the addresses of the shareholders.
// Addresses must be allowed to purchase
// available shares only on the predetermined price.
// Shareholders may withdraw funds only if allowed to.
// Prices and dividends must be ether.

contract MoreAdvancedToken {

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

    function MoreAdvancedToken(uint initialSupply, uint pricePerShare, uint _divident) public {
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

    function buyShares(uint amount) public payable {
        require(sharesPerAddress[owner] >= amount);
        require(sharesPerAddress[msg.sender] + amount >= sharesPerAddress[msg.sender]);
        require(msg.value == amount * price);
        sharesPerAddress[owner] -= amount;
        sharesPerAddress[msg.sender] += amount;
        shareholders.push(msg.sender);
    }

    function getShareholders() public view onlyOwner returns (address[]) {
        return shareholders;
    }

    function allowWithdraw(address _address) public onlyOwner {
        addressesAllowedToWithdraw[_address] = true;
    }

    function depositEarnings() public payable onlyOwner {

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
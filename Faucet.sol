pragma solidity ^0.4.19;

contract Faucet {

    address owner;
    uint256 sendAmount;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier isAmountAvailable() {
        require(this.balance >= sendAmount);
        _;
    }
    
    function Faucet () public {
        owner = msg.sender;
        sendAmount = 1 ether;
    }
    
    function() public payable {
        
    }

    function setSendAmount(uint256 _sendAmount) public onlyOwner {
        sendAmount = _sendAmount;
    }

    function withdraw() public isAmountAvailable {
        sendAmountToAddress(owner);
    }
    
    function sendAmountToAddress(address toAddress) public isAmountAvailable {
        toAddress.transfer(sendAmount);
    }

    function getBalance() public view returns (uint256) {
        return this.balance;
    }

    function kill() public onlyOwner {
        selfdestruct(owner);
    }
    
}
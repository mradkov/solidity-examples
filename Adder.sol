pragma solidity ^0.4.19;

contract Adder {
    
    uint state;
    uint incremented;
    address owner;
    
    event Incremention(uint timestamp, uint _state);
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function Adder(uint _state) public {
        owner = msg.sender;
        state = _state;
        incremented = 0;
    }
    
    function increment () public onlyOwner returns (uint){
        if (incremented + 15 seconds <= now){
            incremented = now;
            state ++;
            
            Incremention(now, state);
        }
        return state;
    }
    
}
pragma solidity ^0.4.19;


contract Incrementor {
    
    uint number = 0;
    
    function Incrementor() public {}
    
    function getNumber() public view returns (uint) {
        return number;
    }
    
    function incrementNumber(uint _value) public {
        number += _value; 
    }
}
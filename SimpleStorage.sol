pragma solidity ^0.4.19;


contract SimpleStorage {
 
    uint private storedData;

    function SimpleStorage() public {
        
    }
    
    function setData(uint x) public {
        storedData = x;
    }
    
    function getData() view public returns (uint) {
        return storedData;
    }
    
}
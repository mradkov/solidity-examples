pragma solidity ^0.4.19;


contract ArrayOfFacts {

    string[] private facts;
    address private contractOwner;  

    modifier onlyOwner() {
        require(msg.sender == contractOwner);
        _;
    }

    function ArrayOfFacts() public {
        contractOwner = msg.sender;
    }

    function addFact(string newFact) public onlyOwner {
        facts.push(newFact);
    }

    function getFact(uint index) public view returns (string) {
        require(index < facts.length);
        return facts[index];
    }

    function getFactCount() public view returns (uint) {
        return facts.length;
    }


}
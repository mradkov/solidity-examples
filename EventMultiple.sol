pragma solidity ^0.4.19;

// Write a contract in Solidity that contains a function
// that receives a string and an address.
// An event must be used that shows the values of these two variables. 

contract EventMultiple {

    address owner;

    event LogInformation(string greeting, address owner);

    function EventMultiple() public {
        owner = msg.sender;
    }

    function showInformation(string greeting) public {
        LogInformation(greeting, owner);
    }

}
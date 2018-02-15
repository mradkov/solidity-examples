pragma solidity ^0.4.19;

// Create an event with multiple parameters that are going to be indexed.

contract EventIndexed {

    address owner;

    event LogInformation(string indexed name, string indexed email);

    function EventIndexed() public {
        owner = msg.sender;
    }

    function showInformation(string name, string email) public {
        LogInformation(name, email);
    }

}
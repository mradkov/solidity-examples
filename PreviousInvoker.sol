pragma solidity ^0.4.19;


contract PreviousInvoker {

    address private previousInvoker;

    function getPreviousInvoker() public returns (address) {
        previousInvoker = msg.sender;
        return previousInvoker;
    }
    
}
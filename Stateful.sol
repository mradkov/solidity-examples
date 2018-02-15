pragma solidity ^0.4.20;

// Write a contract, that:
// Has 3 kinds of states: locked, unlocked and restricted
// The owner can change the state
// Locked means that nobody can call public contract functions (even fallback)
// Unlocked means that everyone can call contract functions
// Restricted means that only the owner can call contract functions
// Have a structure that contains a counter, a timestamp and an address
// Have a function that increments the counter by one, sets the current timestamp
// and sets the address to that of the caller


contract Owned {

    address public owner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function Owned() public {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) public onlyOwner returns (bool) {
        owner = _newOwner;
    }
}


contract Stateful is Owned {
    
    struct Counter {
        uint counter;
        uint timestamp;
        address adr;
    }

    enum State { locked, unlocked, restricted }
    State public state;
    Counter public counter;
    
    modifier stateModifier() {
        require(state == State.locked);
        require(state == State.restricted && msg.sender != owner);
        _;
    }
    
    function Stateful() public {
        owner = msg.sender;
        state = State.unlocked;
    }

    function() public payable stateModifier { }
    
    function changeState(State _newState) public onlyOwner {
        state = _newState;
    }
    
    function increment() public stateModifier {
        counter = Counter({counter: counter.counter++, timestamp: now, adr: msg.sender});
    }
    
}
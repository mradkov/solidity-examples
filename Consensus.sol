pragma solidity ^0.4.19;

// Write a contract, that:
// Can accept ETH
// Has N number of owners (a list of owners given in constructor)
// A proposal can be made to transfer funds to an account (make it a struct)
// For the proposal to be accepted, each owner must agree in the order defined in the list
// For the second owner to agree, the first one has to agree first.
// The same logic for all owners
// If all agree within 5 minutes of the proposal, the proposal is accepted and the funds are transferred
// Include the necessary constraints


contract Consensus {
    
    address[] public owners;
    uint public nextToVote = 0;

    struct Proposal {
        address adr;
        uint amount;
        uint timestamp;
    }
    
    Proposal public proposal;
    
    modifier canPropose() {
        for (uint i = 0; i < owners.length; i++) {
            if(owners[i] == msg.sender){
                _;
                break;
            }
        }
    }

    function Consensus(address[] _owners) public {
        owners = _owners;
    }
    
    function() public payable {}
    
    function propose(address addressPorposal, uint amounProposal) public canPropose {
        require(now > proposal.timestamp + 5 minutes);
        proposal = Proposal({adr: addressPorposal, amount: amounProposal, timestamp: now});
    }
    
    function agree() public {
        require(nextToVote < owners.length);
        require(owners[nextToVote] == msg.sender);
        require( now <= proposal.timestamp +5 minutes);
        require(this.balance >= proposal.amount);
        
        nextToVote++;
        
        if (nextToVote >= owners.length) {
            proposal.adr.transfer(proposal.amount);
        }
    }
    
}
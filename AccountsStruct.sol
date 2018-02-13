pragma solidity ^0.4.19;


contract AccountsStruct {
    
    struct Account {
        string name;
        address addr;
        string email;
    }

    Account[] accounts;
    address contractOwner = msg.sender;

    modifier onlyOwner() {
        require(msg.sender == contractOwner);
        _;
    }

    modifier registeredUser(address addr) {
        require(msg.sender == addr);
        _;
    }

    function AccountsStruct() public {
        
    }

    function createAccount(string _name, address _addr, string _email) public registeredUser(_addr) {
        Account memory newAccount;
        newAccount.name = _name;
        newAccount.addr = _addr;
        newAccount.email = _email;

        accounts.push(newAccount);
    }

    function getAccount(uint index) public view onlyOwner returns (string, address, string) {
        Account memory currentAccount = accounts[index];
        return (currentAccount.name, currentAccount.addr, currentAccount.email);
    }

}
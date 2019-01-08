pragma solidity ^0.4.19;

// Every year, in the ruins of what was once North America, the Capitol of the nation of Panem - 
// a technologically advanced, utopian city where the nation's most wealthy
// and powerful citizens live, forces each of its 12 districts to send a teenage boy and a girl,
// between the ages of 12 and 18, to compete in the Hunger Games: a nationally televised event in which 'tributes'
// fight each other within an arena, until one survivor remains.
//	This time of the year has come and it’s time for the 100th hunger game where you should send
// the new pair of teenage boy and girl.
// Create a Capitol contract which:
// -	adds person by age and gender (hint: use struct for storing the person)
// -	chooses one girl and one boy:
// -	you are not allowed to choose the two people from one gender
// -	they should be between 12 and 18 years old
// -	they should be chosen by random function (you can use block.timestamp but it is not safe or oraclize ->
// learn more about it from oraclize documentation)
// -	you can check how many girls and boys are added -> returns a positive number
// -	after choosing the pair (boy and girl) set the start date of the hunger games 
// and the end date (the hunger games should last 5 minutes)
// -	after the end of the hunger game, check if the boy and girl are alive 
// (use random 0 - dead, 1 - alive, use modifier for checking if the hunger game ended)	
// Use modifiers where it is appropriate.	
// Add appropriate Events for the functions
// Test and play around with the contract!

contract HungerGames {

    bytes32 public randseed;
    address contractOwner;

    modifier onlyOwner() {
        require(msg.sender == contractOwner);
        _;
    }

    struct Person {
        uint8 age;
        bool gender;
        string name;
    }

    Person[] public hungerGamesPlayers;
    event LogPlayerAdded(string indexed _name);

    function HungerGames() public {
        contractOwner = msg.sender;
    }

    function addPerson(string _name, bool _gender, uint8 _age) public onlyOwner {
        Person memory newPlayer = Person({name: _name, gender: _gender, age: _age});
        hungerGamesPlayers.push(newPlayer);
        LogPlayerAdded(newPlayer.name);
    }

    function getPlayersLength() public view returns(uint) {
        return hungerGamesPlayers.length;
    }

    function pseudoRandom(uint start, uint end) public returns (uint) {
        randseed = keccak256(randseed, block.timestamp,
        block.blockhash(block.number-1), block.coinbase,
        block.difficulty, block.number);
        uint range = end - start + 1;
        uint randVal = start + uint256(randseed) % range;
        return randVal;
    }

}
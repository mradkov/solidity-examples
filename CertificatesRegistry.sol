pragma solidity ^0.4.19;


contract CertificatesRegistry {
    
    address contractOwner = msg.sender;
    mapping (string => bool) certificateHashes;
    
    modifier onlyOwner {
        require(msg.sender == contractOwner);
        _;
    }
    
    function addCertificate(string _certificateHash) public onlyOwner {
        certificateHashes[_certificateHash] = true;
    }
    
    function verifyCertificate(string _certificateHash) public view returns(bool){
        return certificateHashes[_certificateHash];
    }

    
}
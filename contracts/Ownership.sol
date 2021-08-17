pragma solidity ^0.6.0;

contract Ownership{

    address private contractOwner;

    constructor(address _owner) public{
        contractOwner = _owner;
    }

    function transferOwnership(address _newOwner) public {
        require(msg.sender == contractOwner);
        contractOwner = _newOwner;
    }

    function owner() public view returns (address owner_){
        owner_ = contractOwner;
    }
}
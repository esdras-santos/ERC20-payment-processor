pragma solidity ^0.6.0;

interface IERC20 {

    function transfer(address _to, uint256 _value) external returns (bool success);


    function transferFrom(address _from, address _to, uint256 _value) external returns(bool success);
}
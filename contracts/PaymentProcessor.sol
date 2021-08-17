pragma solidity ^0.6.0;

import './interfaces/IERC20.sol';
import './Ownership.sol';

contract PaymentProcessor is Ownership{
    
    uint256 private percent;
    IERC20 private token;

    //only for ERC-20 tokens
    mapping (string=>address) private _tokenAddress;
    mapping (address=>mapping(string=>uint256)) private _sellerBalance;
    mapping (string=>uint256) private _ownerBalance;
    mapping (uint256=>address) private _productSeller;

    modifier onlyOwner{
        require(msg.sender == owner(), "only the owner have access to that function.");
        _;
    }

    constructor(address _owner, uint256 _percent) public Ownership(_owner){
        percent = _percent;
    }

    //pay for the product
    function pay(string memory _token,uint256 _amount,uint256 productId) public{
        token = IERC20(_tokenAddress[_token]);
        address seller = _productSeller[productId];
        (uint256 ownerAmount, uint256 sellerAmount) = percentage(_amount, percent);
        bool success = token.transferFrom(msg.sender,address(this), _amount);
        if(success){
            _sellerBalance[seller][_token] += sellerAmount;
            _ownerBalance[_token] += ownerAmount; 
        }
    }

    function balanceOfSeller(address _seller,string memory _token) public view returns(uint256){
        return _sellerBalance[_seller][_token];
    }

    function sellerWithdraw(uint256 _amount, string memory _token) public {
        require(_sellerBalance[msg.sender][_token] >= _amount);
        token = IERC20(_tokenAddress[_token]);
        _sellerBalance[msg.sender][_token] -= _amount;
        bool success = token.transfer(msg.sender,_amount);
        require(success);
    }

    function ownerWithdraw(uint256 _amount, string memory _token) public onlyOwner{
        require(_ownerBalance[_token] >= _amount);
        token = IERC20(_tokenAddress[_token]);
        _ownerBalance[_token] -= _amount;
        bool success = token.transfer(owner(),_amount);
        require(success);
    }

    function ownerBalance(string memory _token) public view onlyOwner returns(uint256){
        return _ownerBalance[_token];
    }

    //add new payment form
    function addToken(string memory _token, address _tokenAddr) public onlyOwner{
        _tokenAddress[_token] = _tokenAddr;
    }

    function setPercent(uint256 newPercent) public onlyOwner{
        percent = newPercent;
    }

    function percentage(uint256 _amount, uint256 _percent) internal pure returns(uint256,uint256){
        uint256 ownerAmount = (_percent * _amount) / 100;
        uint256 sellerAmount = _amount - ownerAmount;
        return (ownerAmount, sellerAmount);
    }
}

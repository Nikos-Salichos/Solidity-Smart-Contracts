// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.17;


contract Ownable  {
  address public owner;
  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  
  constructor() {
    owner = msg.sender;
  }
  
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
  
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }
  
}


contract Authorizable is Ownable {

    mapping(address => bool) public authorized;

    event AuthorizableAddressAdded(address addr);
    event AuthorizableAddressRemoved(address addr);

    modifier onlyAuthorized() {
        require(authorized[msg.sender] || owner == msg.sender);
        _;
    }
    
    function addAuthorizedAddress(address addr) onlyOwner public returns(bool success) {
        if (!authorized[addr]) {
            authorized[addr] = true;
            emit AuthorizableAddressAdded(addr);
            success = true; 
        }
    }
    
    
    function addAuthorizedAddresses(address[] memory addrs) onlyOwner public returns(bool success) {
        for (uint256 i = 0; i < addrs.length; i++) {
            if (addAuthorizedAddress(addrs[i])) {
                success = true;
            }
        }
    }
    
     function removeAddressFromAuthorized(address addr) onlyOwner public returns(bool success) {
        if (authorized[addr]) {
            authorized[addr] = false;
            emit AuthorizableAddressRemoved(addr);
            success = true;
        }
    }
    
     function removeAddressesFromWhitelist(address[] memory addrs) onlyOwner public returns(bool success) {
         for (uint256 i = 0; i < addrs.length; i++) {
             if (removeAddressFromAuthorized(addrs[i])) {
              success = true;
             }
         }
     }
    
    
}

contract CRUD {

    address public owner;
    uint256 public activeProductCounter = 0;
    uint256 public inactiveProductCounter = 0;
    uint256 private productCounter = 0;

    mapping(uint256 => address) public delProductOf;
    mapping(uint256 => address) public productOwnerOf;
    mapping(address => uint256) public productsOf;

    enum Deactivated { NO, YES }
    
    struct ProductStruct {
        uint256 productId;
        string title;
        string description;
        address productOwner;
        Deactivated deleted;
        uint256 created;
        uint256 updated;
    }
    
    ProductStruct[] activeProducts;
    ProductStruct[] inactiveProducts;
    
}

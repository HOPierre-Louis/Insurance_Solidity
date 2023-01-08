// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

interface InterfaceGarage {
    function repairs_request(uint256 _damage) external pure returns (bool, uint256);
}

contract garage {

  function repairs_request(uint256 _damage) external pure returns (bool, uint256){
    uint256 receipt = 0;
    bool repairs=false;
    
    if (_damage > 0 && _damage <= 30){
        receipt = 300;
        repairs = true;
    }
    else if (_damage > 30 && _damage < 60){
        receipt = 600;
        repairs = true;
    }
    else if (_damage >= 60 && _damage < 80){
        receipt = 800;
        repairs = true;
    }
    else if (_damage >= 80 && _damage < 100){
        receipt = 1000;
        repairs = true;
    }
    else repairs = false;
    return (repairs, receipt);
  }
}

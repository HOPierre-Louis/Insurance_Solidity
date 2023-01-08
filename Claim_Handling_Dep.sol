// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "./Customer.sol";
import "./Garage.sol";


interface interfaceClaimHandling {
  function payAmountThirdParty(uint _percentage) external pure returns (uint amount);
  function sendClaimGarage(uint256 _damage) external view returns (bool, uint256);
}

contract claimHandling is customerContract{

  address addressGarage;

  // Fonction qui permet de définir l'addresse du Garage
  function setGarageAddresss(address _garageAddress) public{
    addressGarage = _garageAddress;
  }

  // Fonction qui va retourner l'argent à payer pour le Third-Party
  function payAmountThirdParty(uint _percentage) external pure returns (uint amount){
    if (_percentage > 0 && _percentage <= 30){
      return 300;
    }
    else if (_percentage > 30 && _percentage < 60){
      return 600;
    }
    else if (_percentage >= 60 && _percentage < 80){
      return 800;
    }
    else if (_percentage >= 80 && _percentage < 100){
      return 1000;
    }
    else return 0;
  }

  // Fonction qui permet d'envoyer une requête au garage et revevoir le reçu des reparation
  function sendClaimGarage(uint256 _damage) external view returns (bool, uint256){
    InterfaceGarage _garage = InterfaceGarage(addressGarage);
    
    return _garage.repairs_request(_damage);
  }
}

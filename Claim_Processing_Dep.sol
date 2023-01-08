// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "./Customer.sol";
import "./Claim_Handling_Dep.sol";
import "./Garage.sol";


contract claim_Processing_Dep is customerContract {

   address adressClaimHandling;

   // Fonction qui permet de définir l'addresse du Claim Processing
  function setClaimHandlingAddress(address _claimProcessingAddress) public{
    adressClaimHandling = _claimProcessingAddress;
  }

  // Structure pour stocker les informations d'une demande d'un client Third-Party
  struct Third_Party{
    uint id;
    Customer customer;
    uint percentage;
    bool assessment;
    uint amount_to_be_pay;
  }

  // Structure pour stocker les informations d'une demande d'un client All-Risk
  struct All_Risk{
    uint id;
    Customer customer;
    uint damage;
    bool assessment;
    bool repairs;
    uint receipt;
  }

  // Mapping pour stocker les demandes
  mapping(uint => Third_Party) public claims_third_party;
  mapping(uint => All_Risk) public claims_all_risk;

  // Compteur pour générer des identifiants uniques pour chaque demande 
  uint public claimThirdPartyCount; // Compteur pour les demandes Third-Party
  uint public claimAllRiskCount; // Compteur pour les demandes All-Risk

  // Fonction permettant de vérifier l'identité du client
  function checkCustomer (uint _id, string memory _name, string memory _car, string memory _insuranceType) internal view returns(bool res){
    require(bytes(_name).length > 0, "Invalid name");
    require(bytes(_car).length > 0, "Invalid car name");
    require(bytes(_insuranceType).length > 0, "Invalid insurance type");
    require(keccak256(abi.encodePacked(_insuranceType)) == keccak256(abi.encodePacked(ALL_RISK)) || 
      keccak256(abi.encodePacked(_insuranceType)) == keccak256(abi.encodePacked(THIRD_PARTY)), 
      "Invalid insurance type --> 'All-Risk' or 'Third-Party"
    );

    for(uint i=0; i<= customerCount; i++){
      if(
        (customers[i].id == _id)&&
        (keccak256(abi.encodePacked(customers[i].name)) == keccak256(abi.encodePacked(_name))) &&
        (keccak256(abi.encodePacked(customers[i].car)) == keccak256(abi.encodePacked(_car))) &&
        (keccak256(abi.encodePacked(customers[i].insuranceType)) == keccak256(abi.encodePacked(_insuranceType)))
      ){
        return res = true;
      }
      else return res = false;
    }
  }

  // Fonction permettant de vérifier la date d'expiration du contrat du client
  function checkValidity (uint _id) internal view returns(bool res){
    if (customers[_id].expirationDate > block.timestamp){
      return res = true;
    }
    else return res = false;
  }

  // Fonction permettant de définir l'assessment par rapport à un pourcentage définit
  function setAssessment(uint _percentage) internal pure returns (bool res){
    if (_percentage > 100) return res=false;
    else return res=true;
  }

  // Fonction permettant de classer les demandes en fonction du type d'assurance du client
  function classifyCustomer(uint _id, uint _amount) public {
    require(checkValidity(_id) == true, "The contract has expired");

    if(
      (keccak256(abi.encodePacked(customers[_id].insuranceType)) == "Third-Party") ||
      (keccak256(abi.encodePacked(customers[_id].insuranceType)) == keccak256(abi.encodePacked(THIRD_PARTY)))
    ){
      // Génère un identifiant unique pour une demande de type Third-Party
      uint id = claimThirdPartyCount++;

      // Crée une nouvelle instance de la structure Third-Party avec les informations spécifiées
      Third_Party memory newClaimThird = Third_Party(id, customers[_id], _amount, setAssessment(_amount),0);

      // Enregistre la nouvelle demande dans le mapping
      claims_third_party[id] = newClaimThird;
    }
    else {
      // Génère un identifiant unique pour une demande de type All-Risk
      uint id = claimAllRiskCount++;

      // Crée une nouvelle instance de la structure All-Risk avec les informations spécifiées
      All_Risk memory newClaimAllRisk = All_Risk(id, customers[_id], _amount, setAssessment(_amount),false, 0);

      // Enregistre la nouvelle demande dans le mapping
      claims_all_risk[id] = newClaimAllRisk;
    }
  }

  function sendClaimThird(uint _id) external returns (uint){
    require(claims_third_party[_id].assessment == true, "Assessment is false");
    interfaceClaimHandling claim_Handling = interfaceClaimHandling(adressClaimHandling);
    return claims_third_party[_id].amount_to_be_pay = claim_Handling.payAmountThirdParty(claims_third_party[_id].percentage);
  }

  function sendClaimAll(uint _id) external returns (bool, uint256){
    require(claims_all_risk[_id].assessment == true, "Assessment is false");
    interfaceClaimHandling claim_Handling = interfaceClaimHandling(adressClaimHandling);
    ((claims_all_risk[_id].repairs), (claims_all_risk[_id].receipt)) = claim_Handling.sendClaimGarage(claims_all_risk[_id].damage); 
    return  ((claims_all_risk[_id].repairs), (claims_all_risk[_id].receipt));
  }
}

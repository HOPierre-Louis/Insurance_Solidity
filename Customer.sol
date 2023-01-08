// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "./Claim_Handling_Dep.sol";

contract customerContract {

  // Structure pour stocker les informations d'un client
  struct Customer {
    uint id;
    string name;
    string car;
    string insuranceType;
    uint expirationDate;
  }

  // Mapping pour stocker les clients en fonction de leur identifiant
  mapping(uint => Customer) public customers;

  // Compteur pour générer des identifiants uniques pour chaque client
  uint public customerCount;

  // Templates All-Risk et Third-Party
  string public constant ALL_RISK = "All-Risk";
  string public constant THIRD_PARTY = "Third-Party";

  // Constructeur pour créer un client par défaut lors de la création du contrat
  constructor() {
    addCustomer("GOV Kevin", "Mercedes", ALL_RISK, 1690761600); // expirationDate = 31/07/2023
    addCustomer("HO Pierre-Louis", "BMW", "All-Risk", 1643587200); // expirationDate = 31/01/2022
    addCustomer("LE BARAZER Leo", "Renault", THIRD_PARTY, 1698710400); // expirationDate = 31/10/2023
    addCustomer("DUPONT Tom", "Peugeot", "Third-Party", 1672444800); // expirationDate = 31/12/2022
  }

  
  // Fonction pour ajouter un nouveau client au contrat
  function addCustomer(string memory _name, string memory _car, string memory _insuranceType, uint _expirationDate) public {
    require(bytes(_name).length > 0, "Invalid name");
    require(bytes(_car).length > 0, "Invalid car name");
    require(bytes(_insuranceType).length > 0, "Invalid insurance type");
    require(keccak256(abi.encodePacked(_insuranceType)) == keccak256(abi.encodePacked(ALL_RISK)) || 
      keccak256(abi.encodePacked(_insuranceType)) == keccak256(abi.encodePacked(THIRD_PARTY)), 
      "Invalid insurance type --> 'All-Risk' or 'Third-Party"
    );
    
    // Génère un identifiant unique pour le client
    uint id = customerCount++;

    // Crée une nouvelle instance de la structure Customer avec les informations spécifiées
    Customer memory newCustomer = Customer(id, _name, _car, _insuranceType, _expirationDate);

    // Enregistre le nouveau client dans le mapping
    customers[id] = newCustomer;
  }

  // Fonction pour modifier les informations d'un client
  function updateCustomer(uint _customerId, string memory _name, string memory _car, string memory _insuranceType, uint _expirationDate) public {
    require(bytes(_name).length > 0, "Invalid name");
    require(bytes(_car).length > 0, "Invalid car name");
    require(bytes(_insuranceType).length > 0, "Invalid insurance type");
    require(keccak256(abi.encodePacked(_insuranceType)) == keccak256(abi.encodePacked(ALL_RISK)) || 
      keccak256(abi.encodePacked(_insuranceType)) == keccak256(abi.encodePacked(THIRD_PARTY)), 
      "Invalid insurance type --> 'All-Risk' or 'Third-Party"
    );

    // Met à jour les informations du client
    customers[_customerId].name = _name;
    customers[_customerId].car = _car;
    customers[_customerId].insuranceType = _insuranceType;
    customers[_customerId].expirationDate = _expirationDate;
  }

  // Fonction pour récupérer les informations d'un client en fonction de son identifiant
  function getCustomer(uint _id) public view returns (string memory, string memory, string memory, uint) {
    // Récupère le client avec l'identifiant spécifié dans le mapping
    Customer memory customer = customers[_id];

    // Renvoie les informations du client
    return (customer.name, customer.car, customer.insuranceType, customer.expirationDate);
  }

}

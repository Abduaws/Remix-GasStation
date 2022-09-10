// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract GasStation {



    address payable owner;

    constructor(){
        owner = payable(msg.sender);
    }

    uint gasPrice = 1;

    struct Car {
        string name;
        uint fuelLevel;
        bool init;
    }

    struct Person {
        string name;
        Car car;
        bool init;
    }

    mapping( address => Person ) people;

    function registerPerson(string memory _name) external{
        require(!people[msg.sender].init, "Account Already Registered");
        Person memory p;
        p.name = _name;
        p.init = true;
        people[msg.sender] = p;
    }

    function registerCar(string memory _name) external{
        require(people[msg.sender].init, "No Account Registered");
        people[msg.sender].car = Car(_name, 0, true);
    }

    function getInfo() external view returns (Person memory person){
        require(people[msg.sender].init, "No Account Registered");
        return people[msg.sender];
    }

    function Drive(uint miles) external returns(uint){
        require(people[msg.sender].init, "No Account Registered");
        require(people[msg.sender].car.init, "No Car Registered");
        require(miles<=people[msg.sender].car.fuelLevel);
        people[msg.sender].car.fuelLevel -= miles;
        return people[msg.sender].car.fuelLevel;
    }

    function reFuel(uint level) external payable returns(uint){
        require(people[msg.sender].init, "No Account Registered");
        require(people[msg.sender].car.init, "No Car Registered");
        require((level > people[msg.sender].car.fuelLevel) && (level <= 100));
        uint requiredFuel = level - people[msg.sender].car.fuelLevel;
        uint price = gasPrice * (requiredFuel/100);
        require(msg.value >= price);
        owner.transfer(price);
        people[msg.sender].car.fuelLevel+=requiredFuel;
        return people[msg.sender].car.fuelLevel;
    }
}
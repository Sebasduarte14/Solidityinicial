// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
contract VendingMachine {

/*
Contrato de una machina expendedora con las caracteristicas de :
    1. El contrato debe de tener un propitario: que pueda añadir productos
    o reponer los que ya existen (Solo el propietario).
    2. Solo el propietario va a poder acceder al balance de la maquina. 
    3. Cualquier persona que tenga saldo puede comprar de nuestra maquina. 
    4. El propietaro puede sacar los fondos de la maquina y transferirilos a su cuenta
*/
//Eventos 
event newSnackAdded(string _name, uint _price);
event SnackRestocked (string _name, uint32 _quatity);
event snacksold (string name, uint32 _amount);
// Variables 

    address payable private owner; 
     struct snack {
        uint32 id;
        string name;
        uint32 quantity;
        uint8 price;
     }
    
    snack [] stock; //Variable que almacene los productos
    uint32 totalSnacks;
    constructor (){
        owner = payable(msg.sender); // conversion a payable por que si no no puede
        totalSnacks = 0;    
    }

// Funciones 
    modifier onlyOwner (){
    require(msg.sender == owner);
    _;
    }
    function getallsnacks () external view returns( snack[] memory _stock){
        return stock;
    }

    function addSnack ( string memory _name, uint32 _quantity, uint8 _price) 
     public  onlyOwner {
        require(bytes(_name).length != 0,'ERROR: Nombre vacio');
        require(_quantity != 0,'ERROR EN CANTIDAD');
        require(_price != 0,'ERROR EN PRECIO');
        // No permitir que en nuestro array haya el mismo producto 
        /*for (uint i=0; i<stock.length;i++)
        {
            require(!compareStrings(_name,stock[i].name));
        }*/
        snack memory newSnack = snack(totalSnacks, _name, _quantity, _price*10^18);
        stock.push(newSnack);
        totalSnacks ++;
        emit newSnackAdded(_name, _price);
    }
    function restock (uint32 _id, uint32 _quatity) external onlyOwner {
        require(_quatity !=0, "Null quantity");
        require(_id < stock.length);
        stock[_id].quantity+=_quatity;
        emit SnackRestocked (stock[_id].name,_quatity);
    }

    function getbalancemaquine () external view onlyOwner returns (uint){
        return address(this).balance;
    }
    function withdraw () external onlyOwner{
        owner.transfer(address(this).balance);
    }
    
    function buysnack (uint32 _id, uint32 _amount) external payable  {
        require(_amount > 0 , "Incorrecto valor");
        require (stock[_id].quantity >= _amount, 'insuficient quantity');
        require(msg.value >= _amount*stock[_id].price);
        stock[_id].quantity -= _amount;
        emit snacksold(stock[_id].name, _amount);
    }

    /*function compareStrings ( string memory a, string memory b) internal view 
    returns (bool)
    {
        return (keccak256(abi,encodePacked(a)) == keccak256(abi,encodePacked(b)));
    }*/


}
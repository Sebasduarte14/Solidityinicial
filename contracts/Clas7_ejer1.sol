// SPDX-License-Identifier: MIT
/*
En el segundo ejercicio lo que vamos a hacer es definir el funcionamiento de una habitación de
hotel. El contrato debe tener las siguientes propiedades:
1. Debe tener un propietario al que se van a realizar los pagos cuando se ocupe la
habitación.
2. Debe tener una estructura que defina los dos posibles estados de la habitación de
hotel: ocupada o libre.
3. Al desplegarse el contrato, el estado de la habitación será libre.
4. Debe tener una función que permita ocupar y pagar la habitación. El precio será 1 ether
y se transferirá directamente al propietario del contrato. Si la transacción se realiza
correctamente, emitiremos un evento con la información que veamos conveniente.
5. Para poder pagar y ocupar una habitación, esta tiene que estar libre.
*/
pragma solidity >=0.8.2 <0.9.0;
contract HabitacionHotel 
{
//Eventos 

// Varibales 
address payable owner;
enum Room {libre,ocupado}
Room public currentstatus;
// Funciones
constructor (){
    owner = payable(msg.sender);
    currentstatus = Room.libre;
}
modifier onlyvacnat {
    require (currentstatus == Room.libre, "The room is ocupate");
    _;
}
modifier  costs (uint amount){
    require(msg.value >= amount,"Not enough money");
    _;
}
function book() public payable onlyvacnat costs(1 ether) {
    owner.transfer(msg.value);
     currentstatus = Room.ocupado;

}
}
/*
Un token ERC-20 es en sintesis un smart contract
La intencion es estandarizar la interfaz de creacion
y emision de nuevos tokens en la red.
*/
/*
Los parametros indexados para eventos ,
le permiten buscar estos eventos utilizando parametros indexados como filtros.
*/
/*
Concemos ahora dos palabras reservadas nuevas que son:
virtual: Permite que un contrato que herede de el anule su comportamiento. Es decir que estas funciones se pueden
reescribir.
override: Las funciones overide son las que sobreescirben la funcion base.
*/
/*
Tambien veremos la funcion interna de solidity uncheck ejemplo:
uint = 4;
unchecked{
    num-=value;
}
Si el numero es mayor que el 4 pues esta funcion no tienensentido por lo que con este modificador pues nos a
ahorrramos gas de operaciones que no tienen ningun sentido. 
*/


// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
interface IERC20 
{
    function totalSupply () external view returns (uint256);
    function balanceOf (address account) external view returns (uint256); // Devolver el balnces de los tokens de una cuenta dada
    function transfer (address to, uint256 amount) external  returns (bool); //Tranfiere y confierma
    function allowance (address owner, address spender) external view returns (uint256);// Esta funcion concede permisos a un tercero llamado spender para que gestione una cierta cantidad de tokens, devuelve el numero de tokens que el spender puede utilizar.
    function approve (address spender, uint256 amount) external returns (bool);// el owner autoriza el spender a utilizar dicho amount
    function transferFrom (address from, address to, uint256 amount) external returns (bool); // por medio de esta funcion el spender que ya se le autorizor usar unso tokens, puede tranferirlos a l cuenta suministrada. 
    event Tranfer(address indexed from, address indexed to, uint256 amount);
    event Approval (address indexed from, address indexed to, uint256 amount);
}
contract ERC20 is IERC20
{
    //Eventos 
    //Variables-> Cuando las varibels tiene un barrabja es por que son privadas
    mapping (address => uint256) private _balance;
    mapping (address => mapping(address=>uint256)) private _allowance;//Se hace asi para que el owner tenga control de lo que va a dar de tokens. 
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    //Funciones
    constructor (string memory name_, string memory symbol_)
    {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns (string memory)
    {
        return _name;
    }

    function symbol() public view virtual returns (string memory)
    {
        return _symbol;
    }
    function decimals() public view virtual returns (uint8)
    {
        return 18;//
    }

    function totalSupply() public view virtual override returns (uint256)
    {
        return _totalSupply;
    }
    function balanceOf (address account) public view virtual override returns (uint256)
    {
        return _balance[account];
    }
    function transfer (address to, uint256 amount) public virtual override returns (bool)
    {
        address owner = msg.sender;
        _transfer(owner,to,amount);
        return true;
    }
    function allowance (address owner, address spender) public view virtual override returns (uint256)
    {
        return _allowance[owner][spender];
    }
    function approve (address spender, uint256 amount) public  virtual override returns (bool)
    {
        address owner = msg.sender;
        _approve (owner,spender,amount);
        return true;
    }
    function transferFrom (address from, address to, uint256 amount) public virtual override returns(bool)
    {
        address spender = msg.sender;
        _spendAllowance (from,spender,amount);
        _transfer(from,to,amount);
        return true;
    }
    function increaseAllownace(address spender, uint addvalue ) public virtual returns (bool)
    {
        address owner = msg.sender;
        _approve(owner,spender,allowance(owner,spender)+addvalue);
        return true;
    }
    function decreaseAllowance (address spender, uint256 subtracted)public virtual returns(bool)
    {
        address owner = msg.sender;
        uint256 currentAllowance = allowance(owner, spender);
        require (currentAllowance >= subtracted,"ERROR");
        unchecked
        {
            _approve(owner,spender,currentAllowance-subtracted);
        }
        return true;
    }

    // FUNCIONES INTERNAS
    function _transfer(address from, address to, uint256 amount) internal virtual
    {
        require(from != address(0),"ER20:tranfer from de 0 address");
        require(to != address(0),"ER20:tranfer to de 0 address");

        _beforeTokenTransfer(from,to,amount);
        uint256 frombalance = _balance[from];
        require(frombalance >= amount, "ECR20: Tranfer amount exceeds balance");
        unchecked
        {
            _balance[from]=frombalance-amount;
        }
        _balance[to]+= amount;
        emit Tranfer(from,to,amount);
        _afterTokenTransfer(from,to,amount);
    }
    function _approve (address owner, address spender, uint256 amount) internal virtual
    {
        require(owner != address(0),"ER20:tranfer from de 0 address");
        require(spender != address(0),"ER20:tranfer to de 0 address");

        _allowance[owner][spender] = amount;
        emit Approval(owner,spender,amount);
    }
    function _spendAllowance (address owner, address spender, uint256 amount) internal virtual 
    {
        uint256 currentAllowance = allowance(owner,spender);
        if (currentAllowance != type(uint256).max)
        {
            require(currentAllowance>=amount,"ERC20: Insuficient Balance");
            unchecked
            {
                _approve(owner,spender,currentAllowance-amount);
            }
        }
    }
    function _mit(address account, uint256 amount) internal virtual
    {
        require(account != address(0),"ERC20: mit to the zero address");
        _beforeTokenTransfer(address(0),account,amount);
        _totalSupply += amount;
        unchecked
        {
            _balance[account] +=amount;
        }
        emit Tranfer(address(0), account, amount);
        _afterTokenTransfer(address(0),account,amount);
    }
    function _burn(address account, uint256 amount) internal virtual
    {
        require(account != address(0),"ERC20: mit to the zero address");
        _beforeTokenTransfer(address(0),account,amount);
        uint256 accountBalnce = _balance[account];
        require(accountBalnce>=amount,"ERC20:burn amount exceeds balance");
        unchecked
        {
            _balance[account]-=amount;
            _totalSupply -= amount;
        }
        emit Tranfer(account, address(0), amount);
    }
    function _beforeTokenTransfer(address from,address to, uint256 amount) internal virtual
    {

    }
    function _afterTokenTransfer(address from,address to, uint256 amount) internal virtual
    {

    }
}

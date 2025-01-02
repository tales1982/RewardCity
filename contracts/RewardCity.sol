// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Declaração do contrato RewardCity
contract RewardCity {

    // Mapeamento que armazena os saldos dos usuários (endereço -> saldo)
    mapping(address => uint256) private _balances;

    // Mapeamento que armazena as permissões para transferências (dono dos fundos -> (autorizado -> valor permitido))
    mapping(address => mapping(address => uint256)) private _allowances;

    // Evento emitido quando ocorre uma transferência de tokens
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // Evento emitido quando ocorre uma aprovação de gasto
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // Construtor que inicializa o contrato e define o saldo total para o criador do contrato
    constructor() {
        _balances[msg.sender] = totalSupply(); // O criador do contrato recebe o total de tokens emitidos
    }

    // Retorna o nome do token (padrão ERC20)
    function name() public pure returns (string memory) {
        return "RewardCity"; // Nome do token
    }

    // Retorna o símbolo do token (padrão ERC20)
    function symbol() public pure returns (string memory) {
        return "RWCT"; // Símbolo do token
    }

    // Retorna o número de casas decimais do token (padrão ERC20)
    function decimals() public pure returns (uint8) {
        return 18; // 18 casas decimais, o padrão mais comum em tokens ERC20
    }

    // Retorna a quantidade total de tokens emitidos (padrão ERC20)
    function totalSupply() public view returns (uint256) {
        return 100000 * 10 ** decimals(); // Total de 100.000 tokens com 18 casas decimais
    }

    // Retorna o saldo de tokens de um endereço específico (padrão ERC20)
    function balanceOf(address _owner) public view returns (uint256) {
        return _balances[_owner]; // Saldo do endereço fornecido
    }
    
    // Transfere tokens do remetente para um destinatário (padrão ERC20)
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balanceOf(msg.sender) >= _value, "Insufficient balance"); // Verifica se o remetente tem saldo suficiente
        _balances[msg.sender] -= _value; // Deduz o valor do saldo do remetente
        _balances[_to] += _value; // Adiciona o valor ao saldo do destinatário
        emit Transfer(msg.sender, _to, _value); // Emite o evento de transferência
        return true; // Retorna verdadeiro se a transferência foi bem-sucedida
    }

    // Transfere tokens em nome de outro endereço, com base em uma permissão prévia (padrão ERC20)
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_allowances[_from][msg.sender] >= _value, "Insufficient allowance"); // Verifica se há permissão suficiente
        require(balanceOf(_from) >= _value, "Insufficient balance"); // Verifica se o remetente tem saldo suficiente
        _balances[_from] -= _value; // Deduz o valor do saldo do remetente
        _balances[_to] += _value; // Adiciona o valor ao saldo do destinatário
        _allowances[_from][msg.sender] -= _value; // Reduz a permissão de gasto
        emit Transfer(_from, _to, _value); // Emite o evento de transferência
        return true; // Retorna verdadeiro se a transferência foi bem-sucedida
    }

    // Aprova um endereço para gastar uma quantidade específica de tokens em nome do remetente (padrão ERC20)
    function approve(address _spender, uint256 _value) public returns (bool) {
        _allowances[msg.sender][_spender] = _value; // Define a permissão para o endereço autorizado
        emit Approval(msg.sender, _spender, _value); // Emite o evento de aprovação
        return true; // Retorna verdadeiro se a aprovação foi bem-sucedida
    }

    // Retorna o valor permitido para um endereço gastar em nome de outro (padrão ERC20)
    function allowances(address _owner, address _spender) public view returns (uint256) {
        return _allowances[_owner][_spender]; // Retorna a permissão de gasto
    }
}

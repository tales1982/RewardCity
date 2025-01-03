// SPDX-License-Identifier: MIT
// Declara que este contrato utiliza a licença MIT, permitindo seu uso público.

pragma solidity ^0.8.24;
// Define a versão do Solidity necessária para compilar o contrato.

// Importa contratos de segurança e controle de acesso da biblioteca OpenZeppelin.
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol"; // Protege contra ataques de reentrância.
import "@openzeppelin/contracts/utils/Pausable.sol"; // Permite pausar o contrato em emergências.
import "@openzeppelin/contracts/access/Ownable.sol"; // Permite controle de acesso baseado em um proprietário.

// Interface ERC20, que define o padrão para tokens ERC20.
interface IERC20 {
    // Função para obter o total de tokens em circulação.
    function totalSupply() external view returns (uint256);

    // Função para verificar o saldo de uma conta.
    function balanceOf(address account) external view returns (uint256);

    // Função para transferir tokens para outra conta.
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    // Função para verificar o valor permitido que um endereço pode gastar de outro.
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    // Função para permitir que um endereço gaste uma quantidade específica de tokens.
    function approve(address spender, uint256 amount) external returns (bool);

    // Função para transferir tokens em nome de outro endereço.
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    // Evento emitido quando tokens são transferidos.
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Evento emitido quando um endereço é autorizado a gastar tokens de outro endereço.
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// Define o contrato principal RewardCity, que implementa a interface ERC20 e herda funcionalidades de Ownable, Pausable e ReentrancyGuard.
contract RewardCity is IERC20, Ownable, Pausable, ReentrancyGuard {
    struct Proposal {
        string description;
        uint256 votes;
        bool executed;
        address[] recipients; // Lista de destinatários.
    }

    // Mapeamento para armazenar saldos de contas.
    mapping(address => uint256) private _balances;

    // Mapeamento para armazenar permissões de gastos (allowance).
    mapping(address => mapping(address => uint256)) private _allowances;

    // Mapear a lista negra
    mapping(address => bool) private _blacklist;

    // Variável para armazenar o total de tokens emitidos.
    uint256 private _totalSupply;

    Proposal[] public proposals;

    address private _treasury; // Endereço da tesouraria.
    uint256 private _transactionFee = 10; // Taxa de transação em base 1000 (1% = 10).

    event ProposalCreated(uint256 indexed proposalId, string description);
    event ProposalVoted(
        uint256 indexed proposalId,
        address voter,
        uint256 votes
    );

    // Construtor do contrato.
    // Recebe o endereço do proprietário inicial e define o total de tokens.
    constructor(
        address initialOwner,
        address initialTreasury
    ) Ownable(initialOwner) {
        require(initialTreasury != address(0), "Invalid treasury address");
        _totalSupply = 100000 * 10 ** decimals();
        _balances[initialOwner] = _totalSupply;
        _treasury = initialTreasury; // Inicializa a tesouraria.
    }
    // Retorna o nome do token.
    function name() public pure returns (string memory) {
        return "RewardCity";
    }

    // Retorna o símbolo do token.
    function symbol() public pure returns (string memory) {
        return "REWA";
    }

    // Retorna o número de decimais do token (padrão: 18).
    function decimals() public pure returns (uint8) {
        return 18;
    }

    // Retorna o total de tokens emitidos.
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // Retorna o saldo de uma conta específica.
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    // Transfere tokens de `msg.sender` para `recipient`.
    function transfer(
        address recipient,
        uint256 amount
    ) public override whenNotPaused returns (bool) {
        uint256 fee = (amount * _transactionFee) / 1000; // Calcula a taxa.
        uint256 amountAfterFee = amount - fee; // Subtrai a taxa do valor total.

        require(!_blacklist[msg.sender], "Sender is blacklisted");
        require(!_blacklist[recipient], "Recipient is blacklisted");
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        require(recipient != address(0), "Invalid recipient address");

        _balances[msg.sender] -= amount; // Deduz o saldo do remetente.
        _balances[recipient] += amountAfterFee; // Credita o saldo ao destinatário.
        _balances[_treasury] += fee; // Direciona a taxa para a tesouraria.

        emit Transfer(msg.sender, recipient, amountAfterFee);
        emit Transfer(msg.sender, _treasury, fee);
        return true;
    }

    // Retorna a quantidade permitida que `spender` pode gastar da conta `owner`.
    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    // Permite que `spender` gaste `amount` de tokens da conta de `msg.sender`.
    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _allowances[msg.sender][spender] = amount; // Define a permissão.
        emit Approval(msg.sender, spender, amount); // Emite evento de aprovação.
        return true; // Retorna sucesso.
    }

    // Transfere tokens em nome de outro endereço (`sender` para `recipient`).
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override whenNotPaused returns (bool) {
        require(
            _allowances[sender][msg.sender] >= amount,
            "Insufficient allowance"
        ); // Verifica permissão.
        require(_balances[sender] >= amount, "Insufficient balance"); // Verifica saldo suficiente.
        require(recipient != address(0), "Invalid recipient address"); // Verifica endereço válido.
        require(!_blacklist[sender], "Sender is blacklisted");
        require(!_blacklist[recipient], "Recipient is blacklisted");

        _balances[sender] -= amount; // Deduz o saldo do remetente.
        _balances[recipient] += amount; // Credita o saldo ao destinatário.
        _allowances[sender][msg.sender] -= amount; // Reduz a permissão.

        emit Transfer(sender, recipient, amount); // Emite evento de transferência.
        return true; // Retorna sucesso.
    }

    //Queima de tokens
    function burn(uint256 amount) public {
        require(
            _balances[msg.sender] >= amount,
            "Insufficient balance to burn"
        );
        _balances[msg.sender] -= amount; // Reduz o saldo do remetente.
        _totalSupply -= amount; // Reduz o total de tokens.
        emit Transfer(msg.sender, address(0), amount); // Emite evento de transferência para endereço nulo.
    }

    //Adicionar mais tokens
    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Invalid address");
        require(_totalSupply + amount > _totalSupply, "Overflow error");
        _totalSupply += amount; // Aumenta o total de tokens.
        _balances[to] += amount; // Adiciona tokens ao destinatário.
        emit Transfer(address(0), to, amount); // Emite evento de transferência do endereço nulo para o destinatário.
    }

    //Funcao para adcionar saldo a tessoraria
    function updateTreasury(address newTreasury) public onlyOwner {
        require(newTreasury != address(0), "Invalid address");
        _treasury = newTreasury; // Atualiza o endereço da tesouraria.
    }

    // Pausar e Retomar Funções Específicas
    function pauseTransfers() public onlyOwner {
        _pause();
    }

    //  Pausar e Retomar Funções Específicas
    function unpauseTransfers() public onlyOwner {
        _unpause();
    }

    function createProposal(
        string memory description,
        address[] memory recipients
    ) public onlyOwner {
        proposals.push(Proposal(description, 0, false, recipients));
        emit ProposalCreated(proposals.length - 1, description);
    }

function executeProposal(uint256 proposalId) public onlyOwner nonReentrant {
    require(proposalId < proposals.length, "Invalid proposal");
    Proposal storage proposal = proposals[proposalId];
    require(!proposal.executed, "Proposal already executed");
    require(proposal.votes > 0, "No votes for proposal");

    proposal.executed = true;

    uint256 totalVotes = proposal.votes;

    for (uint256 i = 0; i < proposal.recipients.length; i++) {
        address recipient = proposal.recipients[i];
        require(!_blacklist[recipient], "Recipient is blacklisted");

        uint256 reward = (totalVotes / proposal.recipients.length);
        _balances[recipient] += reward;

        // Log para depuração
        emit Transfer(address(this), recipient, reward);
    }
}




    function vote(uint256 proposalId) public {
        require(proposalId < proposals.length, "Invalid proposal");
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");

        uint256 votes = _balances[msg.sender];
        require(votes > 0, "No tokens to vote");

        proposal.votes += votes;
        emit ProposalVoted(proposalId, msg.sender, votes);
    }

    function setTransactionFee(uint256 fee) public onlyOwner {
        require(fee <= 50, "Fee too high"); // Limita a taxa a 5% (50/1000).
        _transactionFee = fee;
    }

    //Adicione alguma carteira a lista negra
    function blacklistAddress(address account, bool value) public onlyOwner {
        require(account != owner(), "Cannot modify owner blacklist status");
        _blacklist[account] = value;
    }

    function isBlacklisted(address account) public view returns (bool) {
        return _blacklist[account];
    }
}

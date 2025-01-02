# RewardCity - Token RWCT

## Português

### Visão Geral

**RewardCity** é um contrato inteligente ERC20 que implementa um token básico chamado **RWCT**, com funcionalidades como transferências, aprovações e eventos.

---

### Requisitos

- **Node.js** (recomendado: versão 20 ou superior)
- **NPM**
- **Hardhat**

---

### Instruções de Uso

#### 1. Clonar o Repositórionpx hardhat test


git clone https://github.com/tales1982/RewardCity

cd RewardCity

2. Instalar Dependências   
`npm install`   

3. Compilar o Contrato   
Para compilar o contrato RewardCity, execute:   
`npx hardhat compile`   

Se a compilação for bem-sucedida, os arquivos de artefatos serão criados na pasta artifacts/.

4. Implantar o Contrato em uma Rede Local
Inicie a rede local do Hardhat:
npx hardhat node

Implante o contrato:   
`npx hardhat run scripts/deploy.js --network localhost`   
Anote o endereço do contrato exibido no terminal.

5. Testar o Contrato   
Para executar os testes automatizados:   
`npx hardhat test`   

Funcionalidades do Token   
name(): Retorna o nome do token ("RewardCity").   
symbol(): Retorna o símbolo do token ("RWCT").   
decimals(): Retorna o número de casas decimais (18).   
totalSupply(): Retorna o suprimento total de tokens.   
transfer(address, uint256): Transfere tokens para outro usuário.   
approve(address, uint256): Aprova outro usuário para gastar tokens em seu nome.   
transferFrom(address, address, uint256): Transfere tokens de um endereço para outro, com permissão.   
balanceOf(address): Retorna o saldo de um usuário.   
Licença   
Este projeto está licenciado sob a licença MIT.   

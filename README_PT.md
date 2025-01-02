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


# Como Fazer o Deploy do Contrato RewardCity

Este guia explica como configurar e fazer o deploy do contrato RewardCity em uma rede blockchain usando Hardhat.

Pré-requisitos

Node.js: Certifique-se de ter o Node.js instalado  versão v20


Conta MetaMask: Certifique-se de ter uma conta MetaMask configurada com a rede desejada (testnet ou mainnet).

Chave Privada e Alchemy:

Chave privada de sua conta MetaMask.

URL da API da rede blockchain configurada no Alchemy ou outro provedor RPC.

Configuração do Projeto

Configure as Variáveis de Ambiente:
Crie um arquivo .env na raiz do projeto com o seguinte conteúdo:

ALCHEMY_API_URL=<URL_DA_API_ALCHEMY>
PRIVATE_KEY=<SUA_CHAVE_PRIVADA>

Exemplo:

ALCHEMY_API_URL=https://polygon-mumbai.g.alchemy.com/v2/seu-api-key
PRIVATE_KEY=87aa50abe3ebf1b6feea3778dda117c809cc50b3130daf6141dff5a5eedfa738

Verifique o Arquivo hardhat.config.js:
Certifique-se de que o arquivo hardhat.config.js contém a configuração para a rede desejada. Por exemplo:

require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.24",
  networks: {
    polygonAmoyTestnet: {
      url: process.env.ALCHEMY_API_URL,
      accounts: [process.env.PRIVATE_KEY],
      chainId: 80002, // Chain ID da rede Polygon Amoy Testnet
    },
  },
};

Script de Deploy

Certifique-se de que o arquivo scripts/deploy.js está configurado corretamente:

const hre = require("hardhat");

async function main() {
  const RewardCity = await hre.ethers.getContractFactory("RewardCity");
  const rewardCity = await RewardCity.deploy();

  await rewardCity.deployed();

  console.log(`RewardCity deployed to: ${rewardCity.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

Fazendo o Deploy

Certifique-se de que o Node.js está em uma versão suportada:

nvm use 20

Compile o Contrato:

npx hardhat compile

Faça o Deploy:

npx hardhat run scripts/deploy.js --network polygonAmoyTestnet

Resultado Esperado:
Se o deploy for bem-sucedido, você verá uma saída como esta:

RewardCity deployed to: 0x0000000000000000000000000000000000000000

O endereço exibido é onde o contrato foi implantado na rede.

Verificação do Contrato

Acesse um Explorador de Blocos:
Use um explorador compatível (como o PolygonScan para redes Polygon).

Insira o Endereço do Contrato:
Cole o endereço do contrato implantado para verificar sua existência e interagir com ele.

Dicas Adicionais

Obter Tokens Faucet:
Para interagir com a testnet, você precisará de tokens de teste (faucet). Use um faucet como Polygon Faucet.

Erros Comuns:

Chave Privada Inválida: Certifique-se de que sua chave privada está correta e possui 64 caracteres.

Chain ID Incorreto: Verifique se o chainId em hardhat.config.js corresponde à rede configurada no Alchemy e MetaMask.


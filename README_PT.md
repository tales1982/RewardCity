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

### Pré-requisitos

1. **Node.js**
   - Certifique-se de ter o Node.js instalado (versão 20 ou superior).

2. **Conta MetaMask**
   - Configure uma conta MetaMask com a rede desejada (testnet ou mainnet).

3. **Chave Privada e Alchemy**
   - **Chave privada:** Extraía do MetaMask.
   - **URL da API RPC:** Use o Alchemy ou outro provedor para a rede desejada.

### Configuração do Projeto

#### 1. Configure as Variáveis de Ambiente
Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```
ALCHEMY_API_URL=<URL_DA_API_ALCHEMY>
PRIVATE_KEY=<SUA_CHAVE_PRIVADA>
```

**Exemplo:**

```
ALCHEMY_API_URL=https://polygon-mumbai.g.alchemy.com/v2/seu-api-key
PRIVATE_KEY=0000000000000000000000000000000000000000000000000000000000
```

#### 2. Verifique o Arquivo `hardhat.config.js`
Certifique-se de que o arquivo `hardhat.config.js` está configurado para a rede desejada:

### Script de Deploy
Certifique-se de que o arquivo `scripts/deploy.js` está configurado corretamente:

### Fazendo o Deploy

#### 1. Certifique-se de estar usando a versão correta do Node.js
```bash
nvm use 20
```

#### 2. Compile o Contrato
```bash
npx hardhat compile
```

#### 3. Realize o Deploy
```bash
npx hardhat run scripts/deploy.js --network sepolia

```

### Resultado Esperado
Se o deploy for bem-sucedido, você verá algo como:

```
RewardCity deployed to: 0x0000000000000000000000000000000000000000
```

O endereço exibido é onde o contrato foi implantado na rede.

### Verificação do Contrato

1. **Acesse um Explorador de Blocos**
   - Use um explorador compatível (como o PolygonScan para redes Polygon).

2. **Insira o Endereço do Contrato**
   - Cole o endereço do contrato implantado para verificar sua existência e interagir com ele.

### Dicas Adicionais

- **Obtenha Tokens Faucet:**
  - Para interagir com a testnet, obtenha tokens de teste usando faucets como [Polygon Faucet](https://faucet.polygon.technology/).

- **Corrija Erros Comuns:**
  - **Chave Privada Inválida:** Verifique se a chave privada é válida e tem 64 caracteres.
  - **Chain ID Incorreto:** Certifique-se de que o `chainId` em `hardhat.config.js` corresponde à rede configurada no Alchemy e MetaMask.

# Funcionalidades Padrão ERC20

1. **totalSupply:**
Retorna o total de tokens emitidos no contrato.

2. **balanceOf:**
Retorna o saldo de tokens de uma conta específica.

3. **transfer:**
Permite que o remetente transfira tokens para um destinatário, descontando uma taxa de transação.

4. **allowance:**
Retorna o valor que um endereço está autorizado a gastar de outro endereço.

5. **approve:**
Autoriza um endereço a gastar uma quantidade específica de tokens em nome do remetente.

6. **transferFrom:**
Transfere tokens de uma conta para outra usando a permissão previamente concedida por approve.

## Funcionalidades Adicionais

### Tokenomics

7. **Taxa de Transação (_transactionFee):**
Taxa aplicada a cada transferência de tokens.
Configurável pelo proprietário até um limite de 5%.

8. **Tesouraria (_treasury):**
Endereço que acumula as taxas de transação.
Pode ser atualizado pelo proprietário.

## Segurança

9. **Lista Negra (blacklistAddress, isBlacklisted):**
Permite ao proprietário adicionar ou remover endereços da lista negra.
Transferências envolvendo endereços na lista negra são bloqueadas.

10. **Pausar e Retomar Funções (pauseTransfers, unpauseTransfers):**
Permite ao proprietário pausar e retomar transferências de tokens em casos de emergência.

11. **Proteção Contra Reentrância (nonReentrant):**
Evita ataques de reentrância em funções críticas.

## Manipulação de Tokens

12. **Queima de Tokens (burn):**
Permite que um usuário reduza sua quantidade de tokens, diminuindo o total de tokens emitidos.

13. **Criação de Tokens (mint):**
Permite ao proprietário criar novos tokens e creditá-los a um endereço específico.

## Outras Funcionalidades

14. **Definição de Nome e Símbolo:**
name: Nome do token ("RewardCity").
symbol: Símbolo do token ("REWA").

15. **Decimais:**
Define a unidade mínima do token como 10^(-18).

## Eventos

16. **Transfer:**
Emitido em transferências de tokens, incluindo queimas e recompensas.

17. **Approval:**
Emitido ao conceder permissão a um endereço para gastar tokens.

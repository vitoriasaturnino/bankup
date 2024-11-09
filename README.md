# Bankup: Pagamento Automático de Contas

Bankup é um banco digital focado na automação de pagamento de contas recorrentes, com integração via WhatsApp e e-mail, oferecendo praticidade e notificações automáticas para usuários. Esta documentação detalha as funcionalidades do sistema, requisitos, instruções de configuração, execução e testes.

## Índice

1. [Requisitos](#requisitos)
2. [Instalação e Configuração](#instalação-e-configuração)
3. [Rodando a Aplicação](#rodando-a-aplicação)
4. [Testando as Funcionalidades](#testando-as-funcionalidades)
5. [Jobs e Notificações Automáticas](#jobs-e-notificações-automáticas)
6. [Estrutura do Projeto](#estrutura-do-projeto)
7. [Contribuição](#contribuição)

---

## Requisitos

Para executar o projeto Bankup, é necessário ter as seguintes versões do Elixir e Erlang/OTP instaladas:

- **Elixir**: 1.17.3
- **Erlang/OTP**: 27

Além disso, certifique-se de ter o **PostgreSQL** configurado e em execução para o armazenamento de dados.

## Instalação e Configuração

### 1. Clonando o Repositório

Clone o repositório do Bankup:

```bash
git clone https://github.com/seu_usuario/bankup.git
cd bankup
```

### 2. Instalando as Dependências

Instale as dependências do projeto:

```bash
mix deps.get
```

### 3. Configurando o Banco de Dados

Crie e configure o banco de dados. Certifique-se de que o PostgreSQL está em execução e as credenciais de conexão estão corretas em \`config/dev.exs\`:

```bash

# Criação do banco de dados

mix ecto.create

# Executando as migrações

mix ecto.migrate

# Populando o banco de dados com dados de exemplo

mix run priv/repo/seeds.exs
```

### 4. Configurando o Oban e o Swoosh

O projeto usa o Oban para gerenciamento de jobs e o Swoosh para envio de e-mails. Acesse as configurações de \`config.exs\` para ajustar parâmetros de jobs e e-mails conforme suas necessidades.

## Rodando a Aplicação

Para iniciar o servidor Phoenix:

```bash
mix phx.server
```

A aplicação estará disponível em [http://localhost:4000](http://localhost:4000).

> **Nota:** Você pode acessar o **mailbox do Swoosh** em [http://localhost:4000/dev/mailbox](http://localhost:4000/dev/mailbox) para ver os e-mails enviados durante o desenvolvimento.

## Testando as Funcionalidades

Para garantir que a aplicação está funcionando corretamente, você pode executar os comandos abaixo:

### 1. Acessando o IEx e Testando Jobs

Abra o **IEx** com o Phoenix e insira um job para notificações de contas vencidas:

```elixir
iex -S mix phx.server
Bankup.Notifications.DueNotifier.new(%{}) |> Oban.insert()
```

Este comando insere um job no Oban para enviar notificações para contas vencidas. Verifique no **mailbox do Swoosh** ([http://localhost:4000/dev/mailbox](http://localhost:4000/dev/mailbox)) se o e-mail foi enviado corretamente.

### 2. Testando o CRUD de Clientes e Contas

Utilize o dashboard em [http://localhost:4000/dashboard](http://localhost:4000/dashboard) para gerenciar clientes, contas e pagamentos. O sistema permite:

- Adicionar, visualizar e editar configurações de notificação de clientes.
- Gerenciar contas recorrentes, registrando valores e vencimentos.
- Inserir pagamentos e visualizar históricos de pagamento, além de notificações.

## Jobs e Notificações Automáticas

O sistema utiliza o Oban para gerenciar os jobs, sendo responsável pelo envio de notificações automáticas de vencimento de contas e faturas atrasadas.

### Tipos de Notificações

1. **Lembretes de Vencimento**: São enviados com base na frequência configurada em cada conta, avisando sobre faturas a vencer.
2. **Notificações de Atraso**: Disparadas para contas vencidas com multas aplicáveis, notificando o cliente sobre valores pendentes.

Essas notificações são enviadas de acordo com a preferência do cliente (WhatsApp, e-mail ou ambos).

## Estrutura do Projeto

Abaixo está um resumo dos principais módulos e funcionalidades:

- **Bankup.Clients**: Gerencia informações dos clientes, incluindo dados pessoais e histórico de contas.
- **Bankup.RecurringAccounts**: Gerencia contas recorrentes, associadas aos clientes, incluindo descrições, valores e vencimentos.
- **Bankup.Payments**: Lida com o processamento e registro de pagamentos, incluindo status e multas aplicadas.
- **Bankup.Notifications**: Gerencia o sistema de notificações, enviando e-mails para clientes com base nas configurações de lembretes e vencimentos.
- **Bankup.Settings**: Configurações de notificação por cliente, com opções de canais de contato (WhatsApp, e-mail ou ambos).

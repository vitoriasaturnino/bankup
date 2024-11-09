alias Bankup.Repo
alias Bankup.Clients.Client
alias Bankup.RecurringAccounts.RecurringAccount
alias Bankup.Payments.Payment
alias Bankup.Notifications.Notification
alias Bankup.Settings.Setting

# Lista de clientes com dados de exemplo
clients_data = [
  %{
    full_name: "João da Silva",
    cpf_cnpj: "12345678901",
    email: "joao.silva@example.com",
    phone: "11999999999",
    whatsapp: "11999999999",
    country: "Brasil",
    state: "SP",
    city: "São Paulo",
    postal_code: "01000-000",
    street_address: "Rua Exemplo, 123",
    birth_date: ~D[1985-07-20]
  },
  %{
    full_name: "Maria Oliveira",
    cpf_cnpj: "12345678902",
    email: "maria.oliveira@example.com",
    phone: "21988888888",
    whatsapp: "21988888888",
    country: "Brasil",
    state: "RJ",
    city: "Rio de Janeiro",
    postal_code: "20000-000",
    street_address: "Avenida Central, 456",
    birth_date: ~D[1990-03-15]
  },
  %{
    full_name: "Carlos Pereira",
    cpf_cnpj: "12345678903",
    email: "carlos.pereira@example.com",
    phone: "31977777777",
    whatsapp: "31977777777",
    country: "Brasil",
    state: "MG",
    city: "Belo Horizonte",
    postal_code: "30000-000",
    street_address: "Rua da Liberdade, 789",
    birth_date: ~D[1978-12-10]
  }
]

# Inserindo clientes e suas configurações
Enum.each(clients_data, fn client_data ->
  case Repo.insert(%Client{} |> Client.changeset(client_data)) do
    {:ok, client} ->
      # Cria configuração para cada cliente inserido com sucesso
      %Setting{}
      |> Setting.changeset(%{
        client_id: client.id,
        notification_preference: "ambos",
        penalty_limit: 500,
        reminder_frequency: 7
      })
      |> Repo.insert!()

    {:error, changeset} ->
      IO.puts("Erro ao inserir cliente: #{inspect(changeset.errors)}")
  end
end)

# Recuperando o cliente "João da Silva" para associações adicionais
client = Repo.get_by(Client, cpf_cnpj: "12345678901")

# Criação de Contas Recorrentes e Pagamentos
if client do
  account_rent =
    %RecurringAccount{}
    |> RecurringAccount.changeset(%{
      client_id: client.id,
      description: "Aluguel",
      # R$ 1.500,00 em centavos
      amount: 150_000,
      due_date: ~D[2024-11-05],
      payee: "Imobiliária Exemplo",
      pix_key: "example@pix.com",
      status: "ativa"
    })
    |> Repo.insert!()

  account_water =
    %RecurringAccount{}
    |> RecurringAccount.changeset(%{
      client_id: client.id,
      description: "Conta de Água",
      # R$ 70,00 em centavos
      amount: 7000,
      due_date: ~D[2024-11-10],
      payee: "SABESP",
      pix_key: "agua@pix.com",
      status: "ativa"
    })
    |> Repo.insert!()

  # Pagamentos para as contas recorrentes
  %Payment{}
  |> Payment.changeset(%{
    recurring_account_id: account_rent.id,
    amount_paid: 150_000,
    payment_date: ~U[2024-11-04 15:30:00Z],
    payment_method: "PIX",
    payment_status: "concluído",
    penalty_applied: 0
  })
  |> Repo.insert!()

  %Payment{}
  |> Payment.changeset(%{
    recurring_account_id: account_water.id,
    amount_paid: 0,
    payment_status: "pendente",
    penalty_applied: 200
  })
  |> Repo.insert!()

  # Notificações para o cliente e suas contas
  %Notification{}
  |> Notification.changeset(%{
    client_id: client.id,
    recurring_account_id: account_rent.id,
    channel: "ambos",
    content: "Seu aluguel vence amanhã. Pague com o QR code anexado.",
    sent_at: ~U[2024-11-04 09:00:00Z],
    delivery_status: "enviado"
  })
  |> Repo.insert!()

  %Notification{}
  |> Notification.changeset(%{
    client_id: client.id,
    recurring_account_id: account_water.id,
    channel: "ambos",
    content: "Sua conta de água está em atraso.",
    sent_at: ~U[2024-11-11 10:00:00Z],
    delivery_status: "enviado"
  })
  |> Repo.insert!()
end

IO.puts("Dados de exemplo inseridos com sucesso.")

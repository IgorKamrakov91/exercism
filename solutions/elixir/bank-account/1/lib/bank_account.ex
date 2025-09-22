defmodule BankAccount do
  use GenServer

  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account
  def open(args \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, args)
    pid
  end

  @impl true
  def init(_args) do
    {:ok, %{balance: 0, status: :open}}
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account) :: any
  def close(account) do
    GenServer.call(account, :close)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer | {:error, :account_closed}
  def balance(account) do
    GenServer.call(account, :balance)
  end

  @doc """
  Add the given amount to the account's balance.
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(account, amount) do
    GenServer.call(account, {:deposit, amount})
  end

  @doc """
  Subtract the given amount from the account's balance.
  """
  @spec withdraw(account, integer) ::
          :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(account, amount) do
    GenServer.call(account, {:withdraw, amount})
  end

  def handle_call(:balance, _from, %{status: :closed} = state) do
    {:reply, {:error, :account_closed}, state}
  end

  def handle_call(:balance, _from, state) do
    {:reply, state.balance, state}
  end

  def handle_call({:deposit, _amount}, _from, %{status: :closed} = state) do
    {:reply, {:error, :account_closed}, state}
  end

  def handle_call({:deposit, amount}, _from, state) when amount <= 0 do
    {:reply, {:error, :amount_must_be_positive}, state}
  end

  def handle_call({:deposit, amount}, _from, state) do
    new_balance = state.balance + amount
    {:reply, :ok, %{state | balance: new_balance}}
  end

  def handle_call({:withdraw, _amount}, _from, %{status: :closed} = state) do
    {:reply, {:error, :account_closed}, state}
  end

  def handle_call({:withdraw, amount}, _from, state) when amount <= 0 do
    {:reply, {:error, :amount_must_be_positive}, state}
  end

  def handle_call({:withdraw, amount}, _from, state) when amount > state.balance do
    {:reply, {:error, :not_enough_balance}, state}
  end

  def handle_call({:withdraw, amount}, _from, state) do
    new_balance = state.balance - amount
    {:reply, :ok, %{state | balance: new_balance}}
  end

  @impl true
  def handle_call(:close, _from, state) do
    {:reply, :ok, %{state | status: :closed}}
  end
end

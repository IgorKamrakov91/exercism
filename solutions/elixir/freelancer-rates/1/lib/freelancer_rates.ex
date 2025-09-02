defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    # Please implement the daily_rate/1 function
    hourly_rate * 8.0
  end

  def apply_discount(before_discount, discount) do
    # Please implement the apply_discount/2 function
    before_discount - before_discount * discount / 100
  end

  def monthly_rate(hourly_rate, discount) do
    # Please implement the monthly_rate/2 function
    monthly = hourly_rate * 8 * 22
    result = monthly - monthly * discount / 100
    ceil(result)
  end

  def days_in_budget(budget, hourly_rate, discount) do
    # Please implement the days_in_budget/3 function
    state = (hourly_rate - hourly_rate * discount / 100) * 8
    Float.floor(budget / state, 1)
  end
end

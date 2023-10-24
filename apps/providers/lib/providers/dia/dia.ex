defmodule Providers.Dia do
  @moduledoc """
  Documentation for `Dia`.
  """

  @adapter Application.compile_env(:providers, :dia)[:adapter]
  @body Application.compile_env(:providers, :dia)[:body]
  @header Application.compile_env(:providers, :dia)[:header]
  @headers [accept: "#{@header}"]
  @token Application.compile_env(:providers, :dia)[:token]
  @url Application.compile_env(:providers, :dia)[:url]
  @url_push Application.compile_env(:providers, :dia)[:url_push]
  @url_template Application.compile_env(:providers, :dia)[:url_template]

  def auth() do
    case @adapter.post(@url, @body, @headers, params: %{bearerToken: @token}) do
      {:ok, %HTTPoison.Response{body: result}} ->
        token =
          result
          |> Jason.decode!
          |> Map.get("token")

        msg =
          result
          |> Jason.decode!
          |> Map.get("message")

        if msg == nil, do: {:ok, token}, else: {:ok, msg}
    end
  end

  def template(token) do
    headers = ["Authorization": "Bearer #{token}", "Accept": "Application/json", "Content-Type": "application/json"]
    params = %{
      actionType: "message",
      fullText: "Ваш код kjdfnvksjdvndkjsvndksdffdfdbfd3333n djvnskjvsndvkjsdnvkjdn",
      shortText: "йeeeeййВаш код 14543-4553.dcdsc.",
      templateType: "attention",
      title: "Код ОТП"
    }

    case @adapter.post(@url_template, @body, headers, params: params) do
      {:ok, %HTTPoison.Response{body: result}} ->
        template_id =
           result
           |> Jason.decode!
           |> Map.get("templateId")

        msg =
          result
          |> Jason.decode!
          |> Map.get("message")

        if msg == nil, do: {:ok, template_id}, else: {:ok, msg}
    end
  end

  def register(token, template_id) do
    headers = ["Authorization": "Bearer #{token}", "Content-Type": "application/json"]
    params = [
      {"templateId", template_id},
      {"recipients[][id]", "2904412532_18_06"},
      {"recipients[][rnokpp]", "2904412532"}
    ]

    {:ok, %HTTPoison.Response{body: result}} =
      @adapter.post(@url_push, @body, headers, params: params)

    distribution_id =
      result
      |> Jason.decode!
      |> Map.get("distributionId")

    {:ok, distribution_id}
  end

  def status(token, distribution_id) do
    headers = ["Authorization": "Bearer #{token}", "Content-Type": "application/json"]
    url = "https://api2t.diia.gov.ua/api/v1/notification/distribution/push/#{distribution_id}/status"
    params = %{}

    {:ok, %HTTPoison.Response{body: result}} =
      @adapter.post(url, @body, headers, params: params)

    result
  end

  def result(token, distribution_id) do
    headers = ["Authorization": "Bearer #{token}", "Content-Type": "application/json"]
    url = "https://api2t.diia.gov.ua/api/v1/notification/distribution/push/#{distribution_id}"
    params = %{}

    {:ok, %HTTPoison.Response{body: result}} =
      @adapter.post(url, @body, headers, params: params)

    result
  end

  def stop(token, distribution_id) do
    "https://api2t.diia.gov.ua/api/v1/notification/distribution/push/#{distribution_id}"
    headers = ["Authorization": "Bearer #{token}", "Content-Type": "application/json"]
    url = "https://api2t.diia.gov.ua/api/v1/notification/distribution/push/#{distribution_id}"

    {:ok, %HTTPoison.Response{body: result}} =
      @adapter.delete(url, @body, headers)

    result
  end
end

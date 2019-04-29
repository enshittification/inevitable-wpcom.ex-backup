defmodule Wpcom.Req do
  @moduledoc """
  Low-level request functionality for WP.com REST API.

  Accepts GET or POST types. Optional headers. JSON body.
  """

  import Wpcom, only: [api_url: 1]

  @doc "Make a request to WP.com REST API."
  def request(method, path, custom_headers \\ [], body \\ "")

  @spec request(:get | :post, String.t(), [{String.t(), String.t()}], %{}) ::
          {:error, HTTPoison.Error.t()} | {:ok, HTTPoison.Response.t()}
  def request(method, path, custom_headers, body) when is_map(body) do
    request(method, path, custom_headers, Jason.encode!(body))
  end

  @spec request(:get | :post, String.t(), [{String.t(), String.t()}], String.t()) ::
          {:error, HTTPoison.Error.t()} | {:ok, HTTPoison.Response.t()}
  def request(method, path, custom_headers, body) do
    headers = [{"Content-Type", "application/json"}] ++ custom_headers

    HTTPoison.request(method, api_url(path), body, headers)
    |> case do
      {:ok, response} -> {:ok, Jason.decode!(response.body)}
      {:error, response} -> {:error, response.reason}
    end
  end
end

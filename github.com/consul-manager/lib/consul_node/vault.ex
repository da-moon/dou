defmodule ConsulNode.Vault do
	def vault_backend_config(hostname, role_name) do
	    # Check if vault is unsealed
	    consul_headers = ["X-Consul-Token": Cache.Server.fetch(:consul_token, nil)] 

	    vault_url = "http://" <> hostname <> ":8200"
	    Cache.Server.fetch(:vault_url, vault_url)
	    
	    {_status_code, body_health} = http_call(vault_url <> "/v1/sys/health", "GET", [], [])
	    body = Poison.decode!(body_health)

	    if !body["initialized"] do
	      init_data = Poison.encode!(%{"secret_shares" => 5, "secret_threshold" => 5})
	      
	      {_status_code, init_body} = http_call(vault_url <> "/v1/sys/init", "PUT", init_data, [])
	      init = Poison.decode!(init_body)
	      keys = init["keys"]
	      vaultRootToken = init["root_token"]
	      Cache.Server.fetch(:vault_token, vaultRootToken)

	      {_kv_code, kv_written} = http_call(Cache.Server.fetch(:consul_url, nil) <> "/v1/kv/vaultRootToken", "PUT", vaultRootToken, consul_headers)

	      if kv_written != "true" do
	        Color.info "Error: " <> kv_written
	        Color.info "Vault Token not saved in Consul KV Store. Here is your token " <> vaultRootToken
	      end

	      {:ok, sealed} = unseal_with_key(keys)

	      if !sealed do
	        headers = ["X-Vault-Token": "#{vaultRootToken}"] 
	        enable_data = Poison.encode!(%{"type" => "approle"})
	        {status_code, _approle} = http_call(vault_url <> "/v1/sys/auth/approle", "POST", enable_data, headers)

	        if status_code == 204 do
	          role_data = Poison.encode!(%{"policies" => "default"})
	          {status_code_role, _role} = http_call(vault_url <> "/v1/auth/approle/role/#{role_name}", "POST", role_data, headers)
	          if status_code_role == 204 do
	            {_status_code, role_body} = http_call(vault_url <> "/v1/auth/approle/role/#{role_name}/role-id", "GET", [], headers)
	            role = Poison.decode!(role_body)
	            role_id = role["data"]["role_id"]
	            
	            {_status_code, secret_body} = http_call(vault_url <> "/v1/auth/approle/role/#{role_name}/secret-id", "POST", [], headers)
	            secret = Poison.decode!(secret_body)
	            secret_id = secret["data"]["secret_id"]

	            Cache.Server.fetch(:role_id, role_id)
	            Cache.Server.fetch(:secret_id, secret_id)

	            {_kv_code, _kv_written} = http_call(Cache.Server.fetch(:consul_url, nil) <> "/v1/kv/vault/role_id", "PUT", role_id, consul_headers)
	            {_kv_code, _kv_written} = http_call(Cache.Server.fetch(:consul_url, nil) <> "/v1/kv/vault/secret_id", "PUT", secret_id, consul_headers)

	          end
	        end

	      end
	    end
	end

	def unseal_with_key(keys) do
	    key = Enum.at(keys, 0)
	    unseal_data = Poison.encode!(%{"key" => key})
	    {_status_code, unseal_body} = http_call(Cache.Server.fetch(:vault_url, nil) <> "/v1/sys/unseal", "PUT", unseal_data, [])
	    unseal_bod = Poison.decode!(unseal_body)
	    sealed = unseal_bod["sealed"]

	    if sealed do
	      [_head | tail] = keys
	      unseal_with_key(tail)
	    else
	      {:ok, sealed}
	    end
	end

	defp http_call(url, method, data, headers) do
	    response = cond do
	      method == "GET" ->
	         HTTPoison.get!(url, headers)
	      method == "PUT" ->
	         HTTPoison.put!(url, data, headers)
	      method == "POST" ->
	         HTTPoison.post!(url, data, headers)
	      method == "DELETE" ->
	         HTTPoison.delete!(url, headers)
	    end

	    req = response.body
	    status_code = response.status_code

	    {status_code, req}
	end
end

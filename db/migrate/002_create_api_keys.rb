Sequel.migration do
  change do
    create_table(:api_keys) do
      primary_key :id, unique: true
      String :access_token
      DateTime :expires_at
      Integer :user_id, foreign_key: true
    end
  end
end
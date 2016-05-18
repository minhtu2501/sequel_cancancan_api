Sequel.migration do
  change do
    create_table(:roles_users) do
      Integer :role_id
      Integer :user_id
    end
  end
end
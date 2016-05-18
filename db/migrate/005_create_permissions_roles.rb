Sequel.migration do
  change do
    create_table(:permissions_roles) do
      Integer :permission_id
      Integer :role_id
    end
  end
end
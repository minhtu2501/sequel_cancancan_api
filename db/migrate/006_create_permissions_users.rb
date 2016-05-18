Sequel.migration do
  change do
    create_table(:permissions_users) do
      Integer :permission_id
      Integer :user_id
    end
  end
end
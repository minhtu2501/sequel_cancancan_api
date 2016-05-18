Sequel.migration do
  change do
    create_table(:permissions) do
      primary_key :id, unique: true
      String :subject_class
      String :action
    end
  end
end
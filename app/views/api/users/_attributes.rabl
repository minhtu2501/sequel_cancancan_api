object @user
  attributes :id, :name, :email
  child(:roles) do
    attributes :id, :name
  end
object @role
  attributes :id, :name
  child(:permissions) do
    attributes :id, :subject_class, :action
  end
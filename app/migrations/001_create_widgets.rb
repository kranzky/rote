Sequel.migration do
  change do
    create_table :widgets do
      primary_key :id
      String :name, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end

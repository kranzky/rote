Sequel.migration do
  change do
    create_table(:schema_info) do
      column :version, "integer", :default=>0, :null=>false
    end
    
    create_table(:widgets) do
      primary_key :id
      column :name, "text", :null=>false
    end
  end
end

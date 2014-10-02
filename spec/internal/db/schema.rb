ActiveRecord::Schema.define do
  create_table(:supermarkets, :force => true) do |t|
  end
  create_table(:cereals, :force => true) do |t|
    t.string :name
    t.boolean :healthy
    t.float :calories
    t.integer :supermarket_id
    t.timestamps
  end
  create_table(:meats, :force => true) do |t|
    t.string :name
    t.integer :supermarket_id
  end
  create_table(:things, :force => true) do |t|
    t.string :name
    t.string :array
    t.integer :cereal_id
  end
end

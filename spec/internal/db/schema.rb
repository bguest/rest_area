ActiveRecord::Schema.define do
  create_table(:things, :force => true) do |t|
    t.string :name
  end
  create_table(:cereals, :force => true) do |t|
    t.string :name
    t.float :calories
    t.timestamps
  end
end

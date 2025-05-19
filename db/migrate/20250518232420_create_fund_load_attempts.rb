class CreateFundLoadAttempts < ActiveRecord::Migration[7.1]
  def change
    create_enum :fund_load_attempts_import_status, %w[pending failed created]

    create_table :fund_load_attempts_imports, id: :uuid do |t|
      t.bigint :fund_load_attempts_count, null: false, default: 0
      t.enum :status, enum_type: :fund_load_attempts_import_status, default: 'pending', null: false
      t.timestamps
    end

    create_table :customers, id: :uuid do |t|
      t.bigint :external_id, null: false

      t.timestamps
    end

    add_index :customers, :external_id, unique: true

    # TODO: setup partitions (yearly ?) later
    create_table :fund_load_attempts, id: :uuid do |t|
      t.references :fund_load_attempts_import, null: false, foreign_key: true, type: :uuid
      t.references :customer, index: false, null: false, foreign_key: true, type: :uuid
      t.bigint :amount_cents, null: false
      t.datetime :attempted_at, null: false
      t.bigint :external_id, null: false
      t.boolean :accepted

      t.timestamps
    end

    add_index :fund_load_attempts, :external_id, unique: true
    add_index :fund_load_attempts, %i[customer_id external_id], unique: true
    add_index :fund_load_attempts, %i[customer_id attempted_at]
  end
end

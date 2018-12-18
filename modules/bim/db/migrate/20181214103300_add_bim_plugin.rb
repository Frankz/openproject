class AddBimPlugin < ActiveRecord::Migration[5.1]

  def change
    create_table :bim_bcf_issues do |t|
      t.text :uuid, index: true

      t.column :markup, :xml

      t.references :project, foreign_key: { on_delete: :cascade }, index: true
      t.references :work_package, foreign_key: { on_delete: :cascade }, index: { unique: true }
    end

    create_table :bim_bcf_viewpoints do |t|
      t.text :uuid, index: true
      t.text :markup

      t.references :issue,
                   foreign_key: { to_table: :bim_bcf_issues, on_delete: :cascade }

      # Create unique index on issue and uuid to avoid duplicates on resynchronization
      t.index %i[uuid issue_id], unique: true
    end

    create_table :bim_bcf_comments do |t|
      t.text :uuid, index: true
      t.text :comment, null: false
      t.datetime :date, null: false
      t.text :author

      t.references :journal, index: true

      t.references :issue,
                   foreign_key: { to_table: :bim_bcf_issues, on_delete: :cascade },
                   index: true

      # Create unique index on issue and uuid to avoid duplicates on resynchronization
      t.index %i[uuid issue_id], unique: true
    end
  end
end

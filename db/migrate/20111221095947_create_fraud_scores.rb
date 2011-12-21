class CreateFraudScores < ActiveRecord::Migration
  def self.up
    create_table :fraud_scores do |t|
      t.float    :fraud_score
      t.timestamps
    end
  end

  def self.down
    drop_table :fraud_scores
  end
end

class CreateResults < ActiveRecord::Migration
  #  def change
  #    create_table :results do |t|
  #      t.column :call_id, :bigint
  #      t.integer :orderID
  #      t.string :phone
  #      t.string :pass
  #      t.string :dial_start
  #      t.string :dial_dur
  #      t.string :call_result
  #      t.string :call_start
  #      t.string :call_dur
  #      t.integer :on_time
  #    end
  #  end

  def self.up

    execute "CREATE TABLE IF NOT EXISTS `results` (
  `id` bigint(20) NOT NULL auto_increment,
  `call_id` bigint(20) NOT NULL,
  `orderID` int(11) default NULL,
  `phone` varchar(20) default NULL,
  `pass` varchar(15) default NULL,
  `dial_start` varchar(100) default NULL,
  `dial_dur` varchar(15) default NULL,
  `call_result` varchar(100) default NULL,
  `call_start` varchar(100) default NULL,
  `call_dur` varchar(15) default NULL,
  `on_time` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1359314;"

  end

  def self.down
    drop_table :results
  end
end

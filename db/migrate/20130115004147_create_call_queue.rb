class CreateCallQueue < ActiveRecord::Migration
  #  def change
  #    create_table :call_queue, :id => false do |t|
  #      t.column :id, :bigint
  #      t.integer :order
  #      t.string :phone
  #      t.enum :status, :limit => [:NOT_DIALED, :DIALING, :DIALED, :CACHED]
  #      t.string :calleridname, :default => 'ROBOCENT'
  #      t.string :calleridnum, :default => '7578212121'
  #      t.string :recordingname
  #      t.string :dialingserver
  #    end
  #  end

  def self.up

    execute "CREATE TABLE IF NOT EXISTS `call_queue` (
  `id` bigint(20) NOT NULL auto_increment,
  `order` int(11) default NULL,
  `phone` varchar(20) default NULL,
  `status` enum('NOT_DIALED','DIALING','DIALED','CACHED') default NULL,
  `calleridname` varchar(50) default NULL,
  `calleridnum` varchar(30) default NULL,
  `recordingname` varchar(200) default NULL,
  `dialingserver` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  KEY `dialingserver` (`dialingserver`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;"

  end

  def self.down
    drop_table :call_queue
  end
end

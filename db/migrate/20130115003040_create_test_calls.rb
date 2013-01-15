class CreateTestCalls < ActiveRecord::Migration
  #  def change
  #    create_table :test_calls do |t|
  #      t.integer :userID
  #      t.string :phone
  #      t.enum :status, :limit => [:NOT_DIALED, :DIALING, :DIALED, :CACHED]
  #      t.string :calleridname, :default => 'ROBOCENT'
  #      t.string :calleridnum, :default => '7578212121'
  #      t.string :recordingname
  #      t.string :dialingserver
  #    end
  #  end

  def self.up

    execute "CREATE TABLE IF NOT EXISTS `test_calls` (
  `id` int(25) NOT NULL auto_increment,
  `userID` int(11) default NULL,
  `phone` varchar(10) default NULL,
  `status` enum('NOT_DIALED','DIALING','DIALED','CACHED') default NULL,
  `calleridname` varchar(50) default 'ROBOCENT',
  `calleridnum` varchar(30) default '7578212121',
  `recordingname` varchar(200) default NULL,
  `dialingserver` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  KEY `dialingserver` (`dialingserver`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;"

  end

  def self.down
    drop_table :test_calls
  end
end

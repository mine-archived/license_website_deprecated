class Repo < ActiveRecord::Base
  self.table_name = 'repo'
  has_many :case
end

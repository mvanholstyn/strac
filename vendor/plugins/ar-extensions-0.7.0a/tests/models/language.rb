class Language < ActiveRecord::Base
  include ActiveRecord::Extensions::FindToCSV

  belongs_to :developer
end

# == Schema Information
#
# Table name: documents
#
#  id         :integer          not null, primary key
#  file       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Document < ApplicationRecord
  
    #has_one_attached :file
  
end

class User < ApplicationRecord

  has_many :wikis
  has_many :collaborators, dependent: :destroy
  after_initialize :init
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:standard, :premium, :admin]

  def init
    self.role ||= :standard
  end

  def collaborator_for(wiki)
     collaborators.where(wiki_id: wiki.id).first
   end
end

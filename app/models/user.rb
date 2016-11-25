class User < ApplicationRecord

  has_many :wikis
  after_initialize :init
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:standard, :premium, :admin]

  def init
    self.role ||= :standard
  end
end

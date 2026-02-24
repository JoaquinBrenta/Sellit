class User < ApplicationRecord
    has_secure_password

    validates :email, presence: true, uniqueness: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)+\z/i, message: :invalid }
    validates :username, presence: true, uniqueness: true, length: { in: 3..15}, format: { with: /\A[a-zA-Z0-9_]+\z/, message: :invalid }
    validates :password, presence: true, length: { minimum: 6 }, if: :password_digest_changed?
    

    has_many :products, dependent: :destroy
    has_many :favorites, dependent: :destroy
    before_save :downcase_attributes

    private

    def downcase_attributes
        self.username = username.downcase
        self.email = email.downcase
    end
end

module Error
    extend ActiveSupport::Concern
    
    included do
    rescue_from ActiveRecord::RecordNotFound do
    redirect_to products_path, alert: 'The requested resource was not found.'
    end
end
end
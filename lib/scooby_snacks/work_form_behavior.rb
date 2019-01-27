module ScoobySnacks::WorkFormBehavior
  extend ActiveSupport::Concern  
  included do
    
    work_type_attributes = ScoobySnacks::METADATA_SCHEMA.with_indifferent_access['work_types'][self.model_class.human_readable_type.downcase.gsub(' ', '_')]

    self.terms = []
    work_type_attributes["display_terms"]&.each do |property_name|
      self.terms << property_name.to_sym
      delegate property_name.to_sym, to: :model
    end

    self.required_fields = []
    work_type_attributes["required"]&.each do |property_name|
      self.required_fields << property_name.to_sym
    end  
    
    def primary_terms 
      return @primary_terms if !@primary_terms.nil?
      pt = []
      ScoobySnacks::METADATA_SCHEMA.with_indifferent_access['work_types'][self.model_class.human_readable_type.downcase.gsub(' ', '_')]["primary"]&.each do |property_name|
        pt << property_name.to_sym
      end
      @primary_terms = pt
    end

    def self.build_permitted_params
      params = super
      ScoobySnacks::METADATA_SCHEMA.with_indifferent_access['work_types'][self.model_class.human_readable_type.downcase.gsub(' ', '_')]["controlled"]&.each do |property_name|
        params << {"#{property_name}_attributes".to_sym => [:id, :_destroy]}
      end
      puts "TEST MOTEHRFAKJ"
      Rails.logger.error('TEST MOOOSJA')
      return params
    end


  end
end

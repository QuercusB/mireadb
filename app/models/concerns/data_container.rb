module DataContainer
	extend ActiveSupport::Concern

	included do
		serialize :data, Hash

		def self.data_field(name)
			define_method("#{name}") {
				data[name.to_s]
			}
			define_method("#{name}=") { |value|
				data[name.to_s] = value
			}
		end
	end

end
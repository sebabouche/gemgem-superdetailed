class Thing < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Thing, :create

    contract Contract::Create
    
    include Dispatch
    callback :default, Callback::Default

    def process(params)
      validate(params[:thing]) do |f|
        upload_image!(f)
        f.save
        dispatch!
      end
    end

  private
    def reset_authorships!
      model.authorships.each { |authorship| authorship.update_attribute(:confirmed, 0) }
    end

    def upload_image!(contract)
      contract.image!(contract.file) do |v|
        v.process!(:original)
        v.process!(:thumb) { |job| job.thumb!("120x120#") }
      end
    end
  end

  class Update < Create
    action :update

    contract Contract::Update
  end
end

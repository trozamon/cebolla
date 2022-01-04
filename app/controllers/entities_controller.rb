class EntitiesController < AuthedController
  def edit
    @entity = Entity.includes(:address).find(params[:id])
    @entity.build_address if @entity.address.blank?
  end

  def create
    Entity.create!(entity_params)
    redirect_to entities_path
  end

  def index
    @entities = Entity.all
  end

  def new
    @entity = Entity.new
    @entity.build_address
  end

  def update
    @entity = Entity.find(params[:id])
    @entity.update!(entity_params)
    redirect_to entities_path
  end

  private

  def entity_params
    params.require(:entity)
          .permit(:name,
                  :email,
                  :phone,
                  address_attributes: %i[city id line1 line2 state zip])
  end
end

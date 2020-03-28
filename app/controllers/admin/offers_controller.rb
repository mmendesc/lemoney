# frozen_string_literal: true

class Admin::OffersController < Admin::ApplicationController
  before_action :set_offer, except: %w(index create)

  def index
    @offers = Offer.all
  end

  def show; end

  def new
    @offer = Offer.new
  end

  def edit; end

  def create
    @offer = Offers::CreateService.run(offer_params).result

    respond_to do |format|
      if @offer.persisted?
        format.html { redirect_to [:admin, @offer], notice: 'Offer was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if Offers::UpdateService.run(@offer, offer_params)
        format.html { redirect_to [:admin, @offer], notice: 'Offer was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @offer.destroy
    respond_to do |format|
      format.html { redirect_to offers_url, notice: 'Offer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def disable
    respond_to do |format|
      if @offer.update(status: :disabled)
        format.html { redirect_to [:admin, @offer], notice: 'Offer was successfully disabled.' }
      else
        format.html { redirect_to [:admin, @offer], notice: 'There was an error.' }
      end
    end
  end

  def enable
    respond_to do |format|
      if @offer.update(status: :enabled)
        format.html { redirect_to [:admin, @offer], notice: 'Offer was successfully enabled.' }
      else
        format.html { redirect_to [:admin, @offer], notice: 'There was an error.' }
      end
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(
      :advertiser_name, :description, :url, :premium,
      :starts_at, :ends_at
    )
  end
end

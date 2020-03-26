# frozen_string_literal: true

class Admin::OffersController < Admin::ApplicationController
  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  def index
    @offers = Offer.all
  end

  def show
  end

  def new
    @offer = Offer.new
  end

  def edit
  end

  def create
    @offer = Offer.new(offer_params)

    respond_to do |format|
      if @offer.save
        launch_jid = ::Offers::LaunchWorker.perform_at(@offer.starts_at, @offer.id)
        @offer.update(launch_jid: launch_jid)
        format.html { redirect_to [:admin, @offer], notice: 'Offer was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      old_starts_at = @offer.starts_at
      if @offer.update(offer_params)
        if @offer.starts_at != old_starts_at
          launch_jid = ::Offers::LaunchWorker.perform_at(@offer.starts_at, @offer.id)
          @offer.update(launch_jid: launch_jid)
        end
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
    if @offer.update(status: :disabled)
      format.html { redirect_to [:admin, @offer], notice: 'Offer was successfully disabled.' }
    else
      format.html { redirect_to [:admin, @offer], notice: 'There was an error.' }
    end
  end

  def enable
    if @offer.update(status: :enabled)
      format.html { redirect_to [:admin, @offer], notice: 'Offer was successfully enabled.' }
    else
      format.html { redirect_to [:admin, @offer], notice: 'There was an error.' }
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

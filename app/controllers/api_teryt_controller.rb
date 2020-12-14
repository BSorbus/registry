# frozen_string_literal: true
class ApiTerytController < ApplicationController

  def items
    items_obj = ApiTerytAddress.new(q: "#{params[:q]}", page: "#{params[:page]}", page_limit: "#{params[:page_limit]}")
    if items_obj.request_for_collection # return true
      render json: JSON.parse(items_obj.response.body), status: items_obj.response.code
    else
      if items_obj.response.present?
         render json: { error: items_obj.response.message }, status: items_obj.response.code 
      else 
         render json: { error: items_obj.errors.messages }, status: :unprocessable_entity
      end
    end
  end

  def item_show
    item_obj = ApiTerytAddress.new(combine_id: params[:id])
    if item_obj.request_for_one_row
      render json: JSON.parse(item_obj.response.body), status: item_obj.response.code
    else
      if item_obj.response.present?
         render json: { error: item_obj.response.message }, status: item_obj.response.code 
      else 
         render json: { error: item_obj.errors.messages }, status: :unprocessable_entity
      end
    end
  end

  def provinces
    items_obj = ApiTerytProvince.new(q: "#{params[:q]}", page: "#{params[:page]}", page_limit: "#{params[:page_limit]}")
    if items_obj.request_for_collection # return true
      render json: JSON.parse(items_obj.response.body), status: items_obj.response.code
    else
      if items_obj.response.present?
         render json: { error: items_obj.response.message }, status: items_obj.response.code 
      else 
         render json: { error: items_obj.errors.messages }, status: :unprocessable_entity
      end
    end
  end

  def province_show
    item_obj = ApiTerytProvince.new(id: params[:id])
    if item_obj.request_for_one_row
      render json: JSON.parse(item_obj.response.body), status: item_obj.response.code
    else
      if item_obj.response.present?
         render json: { error: item_obj.response.message }, status: item_obj.response.code 
      else 
         render json: { error: item_obj.errors.messages }, status: :unprocessable_entity
      end
    end
  end

  def province_districts
    items_obj = ApiTerytProvinceDistricts.new(id: params[:province_id], q: "#{params[:q]}", page: "#{params[:page]}", page_limit: "#{params[:page_limit]}")
    if items_obj.request_for_collection # return true
      render json: JSON.parse(items_obj.response.body), status: items_obj.response.code
    else
      if items_obj.response.present?
         render json: { error: items_obj.response.message }, status: items_obj.response.code 
      else 
         render json: { error: items_obj.errors.messages }, status: :unprocessable_entity
      end
    end
  end

  def district_show
    item_obj = ApiTerytDistrict.new(id: params[:id])
    if item_obj.request_for_one_row
      render json: JSON.parse(item_obj.response.body), status: item_obj.response.code
    else
      if item_obj.response.present?
         render json: { error: item_obj.response.message }, status: item_obj.response.code 
      else 
         render json: { error: item_obj.errors.messages }, status: :unprocessable_entity
      end
    end
  end

  def district_communes
    items_obj = ApiTerytDistrictCommunes.new(id: params[:district_id], q: "#{params[:q]}", page: "#{params[:page]}", page_limit: "#{params[:page_limit]}")
    if items_obj.request_for_collection # return true
      render json: JSON.parse(items_obj.response.body), status: items_obj.response.code
    else
      if items_obj.response.present?
         render json: { error: items_obj.response.message }, status: items_obj.response.code 
      else 
         render json: { error: items_obj.errors.messages }, status: :unprocessable_entity
      end
    end
  end

  def commune_show
    item_obj = ApiTerytCommune.new(id: params[:id])
    if item_obj.request_for_one_row
      render json: JSON.parse(item_obj.response.body), status: item_obj.response.code
    else
      if item_obj.response.present?
         render json: { error: item_obj.response.message }, status: item_obj.response.code 
      else 
         render json: { error: item_obj.errors.messages }, status: :unprocessable_entity
      end
    end
  end


end

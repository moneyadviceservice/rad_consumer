class SearchController < ApplicationController
  MAX_RANDOM_SEED_VALUE = 1024

  def index
    @form = SearchForm.new(search_form_params)

    if @form.valid?
      @result = FirmRepository.new.search(@form.to_query, page: page)
      respond_to do |format|
        format.html { render :index }
        format.json { render body: parse(result: @result.firms).to_json }
      end
    else
      respond_to do |format|
        format.html { render searchable_view }
        format.json { render body: parse.to_json }
      end
    end
  end

  def search_filter_options_description?
    false
  end

  helper_method :search_filter_options_description?

  private

  def searchable_view
    from_results? ? 'search/index' : 'landing_page/show'
  end

  def from_results?
    params.key?(:origin)
  end

  def random_search_seed
    session[:random_search_seed] ||= rand(MAX_RANDOM_SEED_VALUE)
  end

  def search_form_params
    case request.format
    when 'json'
      firm_search_params
    else
      params.require(:search_form).merge(random_search_seed: random_search_seed)
    end
  end

  def firm_search_params
    { pension_pot_size: 'any',
      postcode: '',
      advice_method: 'firm_name_search',
      firm_name: params[:term],
      random_search_seed: random_search_seed
    }
  end

  def parse(result: [])
    return result if result.empty?

    result.map! do |firm|
      {
        label: firm.name,
        value: firm_path(id: firm.id, search_form: firm_search_params)
      }
    end
  end
end

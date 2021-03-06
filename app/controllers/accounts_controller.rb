class AccountsController < ApplicationController
  @@parameters = Parameter.first  
  
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def index
    @error_messages = []
    @enabled_accounts = get_enabled_or_disabled_accounts("1")
  end
  
  def disabled_accounts
    @error_messages = []
    @disabled_accounts = get_enabled_or_disabled_accounts("2")
  end
  
  def get_enabled_or_disabled_accounts(status)
    # communication with back office
    @request = Typhoeus::Request.new(URI.escape("#{@@parameters.back_office_url}/PAYMONEY-NGSER/rest/BACKOFFICECompteList/GetAllCompte/#{status}"), followlocation: true)        
    @internal_com_request = "@response = request.response.body"        
    run_typhoeus_request(@request, @internal_com_request)
    if !@response.blank?
      if @response.match(/\[\{\"idCompte/).blank?
          @accounts = JSON.parse(@response.sub(/\:/, ":[").sub(/\}\}$/, "}]}"))
        unless @accounts.blank?
          @accounts = Kaminari.paginate_array(@accounts["compte"]).page(params[:page]).per(10)
        end
      else
        @accounts = JSON.parse(@response)
        unless @accounts.blank?
          @accounts = Kaminari.paginate_array(@accounts["compte"]).page(params[:page]).per(10)
        end
      end
    end
    
    @accounts
  end
  
  def credits
    # status = 1
    @account = search_account(params[:email])
    @operations = get_credit_or_debit_operations(@account["idCompte"], 1)
  end
  
  def debits
    # status = 2
    @account = search_account(params[:email])
    @operations = get_credit_or_debit_operations(@account["idCompte"], 2)
  end
  
  def get_credit_or_debit_operations(account_id, status)
    @connexion = ActiveRecord::Base.establish_connection(
      :adapter  => "mysql",
      :host     => "localhost",
      :port     => 3306,
      :encoding => "utf8",
      :username => "root",
      :password => "jason",
      :database => "PayMoneyDB"
    )    
    @results = @connexion.connection.execute("SELECT * FROM operation WHERE type_oper_idtype_oper = #{status} AND Compte_idCompte = #{account_id}")
    
    @connexion = ActiveRecord::Base.establish_connection(
      :adapter  => "postgresql",
      :host     => "localhost",
      :port     => 5432,
      :encoding => "utf8",
      :username => "o1",
      :password => "com99123",
      :database => "PaymoneyAdministration_development"
    )
    @results = Kaminari.paginate_array(@results.to_a).page(params[:page]).per(10)
    @results
  end
  
  def enable_account
	  enable_disable_account(params[:account_id], true, "activé", "UnCompte", "1")
	end
	
	def disable_account
	  enable_disable_account(params[:account_id], false, "désactivé", "LKC", "2")
	end
	
	def enable_disable_account(id, bool, status, custom_link, expected_response)
	  @error_messages = []
	  @message = ""
	  
	  @request = Typhoeus::Request.new(URI.escape("#{@@parameters.back_office_url}/PAYMONEY-NGSER/rest/BACKOFFICECompteList/#{custom_link}/#{id}"), followlocation: true)        
    @internal_com_request = "@response = request.response.body"        
    run_typhoeus_request(@request, @internal_com_request)
    
    @status = JSON.parse(@response)
    if @status["idStatus"] == expected_response
      @message = "Le compte ayant pour numéro: #{id} a été #{status}"
    else
      @message = "Une erreur s'est produite, veuillez contacter l'administrateur."
    end
	  
	  redirect_to :back, :notice => @message
	end
	
	def search
	  @error_messages = []
	  @terms = params[:terms]
	  
	  if @terms.blank?
	    @error_messages << "Aucun terme de recherche n'a été entré."
	  else 
	    # communication with back office
      @request = Typhoeus::Request.new(URI.escape("#{@@parameters.back_office_url}/PAYMONEY-NGSER/rest/BACKOFFICECompteList/GetAllCompte_All_MUTI_CRITERE/#{@terms}"), followlocation: true)        
      @internal_com_request = "@response = request.response.body"        
      run_typhoeus_request(@request, @internal_com_request)
      if !@response.blank?
        if @response.match(/\[\{\"idCompte/).blank?
          @accounts = JSON.parse(@response.sub(/\:/, ":[").sub(/\}\}$/, "}]}"))
          unless @accounts.blank?
            @accounts = Kaminari.paginate_array(@accounts["compte"]).page(params[:page]).per(10)
          end
        else
          @accounts = JSON.parse(@response)
          unless @accounts.blank?
            @accounts = Kaminari.paginate_array(@accounts["compte"]).page(params[:page]).per(10)
          end
        end
      end
    end
	end
	
	def search_account(terms)
	  @error_messages = []
	  @account = nil
	  @request = Typhoeus::Request.new(URI.escape("#{@@parameters.back_office_url}/PAYMONEY-NGSER/rest/BACKOFFICECompteList/GetAllCompte_All_MUTI_CRITERE/#{terms}"), followlocation: true)        
    @internal_com_request = "@response = request.response.body"        
    run_typhoeus_request(@request, @internal_com_request)
    if !@response.blank?
      @accounts = JSON.parse(@response.sub(/\:/, ":[").sub(/\}\}$/, "}]}")).first[1].first
    end
    @accounts
	end
  
end

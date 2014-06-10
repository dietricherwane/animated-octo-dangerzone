class ProfilesController < ApplicationController
  @@parameters = Parameter.first  
  @@url = "http://hub.com"
  
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def custom_profiles
  
  end
  
  def auditor_index
    @namecss = @shortcutcss = "row-form"
    @profiles = Profile.where("shortcut NOT IN ('ADMIN-P', 'ADMIN-R', 'ADMIN-A', 'GBUM')").page(params[:page]).per_page(17)
  end
  
  def users_per_profile
    @profile = Profile.find_by_id(params[:profile_id])
    if @profile.blank?
      redirect_to auditor_index_path, :notice => "Ce profil n'existe pas."
    else
      @users = User.where("profile_id = #{@profile.id}").page(params[:page]).per_page(17)
    end
  end
  
  def index
    @namecss = @shortcutcss = "row-form"
    @profiles = Profile.where("shortcut NOT IN ('ADMIN-P', 'ADMIN-R', 'ADMIN-A', 'GBUM')").page(params[:page]).per_page(17)
  end
  
  def create
    @error_messages = []
    @success_messages = []
    @namecss = @shortcutcss = "row-form"
    @name = params[:name]
    @shortcut = params[:shortcut]
    @profiles = Profile.where("shortcut NOT IN ('ADMIN-P', 'ADMIN-R', 'ADMIN-A', 'GBUM')").page(params[:page]).per_page(17)

    if Profile.find(:all, :conditions => ["name ILIKE ? OR shortcut ILIKE ?", @name, @shortcut]).blank?
      @fields = [[@name, "le nom du profil", "@namecss"], [@shortcut, "l'abbréviation du profil", "@shortcutcss"]]
      
      @fields.each do |field|
        if field[0].blank?
          @error_messages << "Veuillez entrer #{field[1]}."
          my_container = field[2]
          instance_variable_set("#{my_container}", "row-form error")
          @error = true
        end
      end
      
      unless @error 
        Profile.create(name: @name, shortcut: @shortcut.upcase)
        params[:name] = params[:shortcut] = nil
        @success_messages << "Le profil #{@name} a été créé." 
      end
    else
      @error_messages << "Le nom du profil ainsi que son abbréviation doivent être uniques."
    end
    
    render :action => "index"
  end
  
  def edit
    @namecss = @shortcutcss = "row-form"
     @profiles = Profile.where("shortcut NOT IN ('ADMIN-P', 'ADMIN-R', 'ADMIN-A', 'GBUM')").page(params[:page]).per_page(17)
    @profile = Profile.find_by_id(params[:id])
  end
  
  def update
    @error_messages = []
    @success_messages = []
    @namecss = @shortcutcss = "row-form"
    @profile = Profile.find_by_id(params[:id])
    @name = params[:name]
    @shortcut = params[:shortcut]
    @profiles = Profile.where("shortcut NOT IN ('ADMIN-P', 'ADMIN-R', 'ADMIN-A', 'GBUM')").page(params[:page]).per_page(17)

    if Profile.find(:all, :conditions => ["(name ILIKE ? OR shortcut ILIKE ?) AND id != ?", @name, @shortcut, @profile.id]).blank?
      @fields = [[@name, "le nom du profil", "@namecss"], [@shortcut, "l'abbréviation du profil", "@shortcutcss"]]
      
      @fields.each do |field|
        if field[0].blank?
          @error_messages << "Veuillez entrer #{field[1]}."
          my_container = field[2]
          instance_variable_set("#{my_container}", "row-form error")
          @error = true
        end
      end
      
      unless @error 
        @profile.update_columns(name: @name, shortcut: @shortcut.upcase)
        @success_messages << "Le profil #{@name} a été mis à jour." 
      end
    else
      @error_messages << "Le nom du profil ainsi que son abbréviation doivent être uniques."
    end
    
    
    render :action => "edit" 
  end
  
  def edit_rights
    @profiles = Profile.where("shortcut NOT IN ('ADMIN-P', 'ADMIN-R', 'ADMIN-A', 'GBUM')").order("name ASC").page(params[:page]).per_page(17)
  end
  
  def enable_create_user_right
    create_user_right(true, params[:id], "a maintenant")
  end
  
  def disable_create_user_right
    create_user_right(false, params[:id], "n'a plus")
  end
  
  def create_user_right(status, id, message)
    @profile = Profile.find_by_id(id)
    @profile.update_attributes(create_user: status)
    
    redirect_to edit_profiles_rights_path, :notice => "Le profil #{@profile.name} #{message} le droit de créer des utilisateurs."
  end
  
  def enable_edit_user_data_right
    edit_user_data_right(true, params[:id], "a maintenant")
  end
  
  def disable_edit_user_data_right
    edit_user_data_right(false, params[:id], "n'a plus")
  end
  
  def edit_user_data_right(status, id, message)
    #@profiles = Profile.where("shortcut NOT IN ('ADMIN-P', 'ADMIN-R', 'ADMIN-A', 'GBUM')").page(params[:page]).per_page(17)
    @profile = Profile.find_by_id(id)
    @profile.update_attributes(edit_user_data: status)
    
    redirect_to edit_profiles_rights_path, :notice => "Le profil #{@profile.name} #{message} le droit de modifier les profils utilisateurs."
  end
  
  def enable_create_profile_right
    create_profile_right(true, params[:id], "a maintenant")
  end
  
  def disable_create_profile_right
    create_profile_right(false, params[:id], "n'a plus")
  end
  
  def create_profile_right(status, id, message)
    @profile = Profile.find_by_id(id)
    @profile.update_attributes(create_profile: status)
    
    redirect_to edit_profiles_rights_path, :notice => "Le profil #{@profile.name} #{message} le droit de modifier les profils utilisateurs."
  end
  
  def enable_edit_profile_right
    edit_profile_right(true, params[:id], "a maintenant")
  end
  
  def disable_edit_profile_right
    edit_profile_right(false, params[:id], "n'a plus")
  end
  
  def edit_profile_right(status, id, message)
    @profile = Profile.find_by_id(id)
    @profile.update_attributes(edit_profile: status)
    
    redirect_to edit_profiles_rights_path, :notice => "Le profil #{@profile.name} #{message} le droit de modifier les profils utilisateurs."
  end
  
  def enable_view_transactions_right
    view_transactions_right(true, params[:id], "a maintenant")
  end
  
  def disable_view_transactions_right
    view_transactions_right(false, params[:id], "n'a plus")
  end
  
  def view_transactions_right(status, id, message)
    @profile = Profile.find_by_id(id)
    @profile.update_attributes(view_transactions: status)
    
    redirect_to edit_profiles_rights_path, :notice => "Le profil #{@profile.name} #{message} le droit de visualiser les transactions."
  end
  
  def enable_disable_account_right
    disable_account_right(true, params[:id], "a maintenant")
  end
  
  def disable_disable_account_right
    disable_account_right(false, params[:id], "n'a plus")
  end
  
  def disable_account_right(status, id, message)
    @profile = Profile.find_by_id(id)
    @profile.update_attributes(disable_account: status)
    
    redirect_to edit_profiles_rights_path, :notice => "Le profil #{@profile.name} #{message} le droit d'ctiver/désactiver des comptes Paymoney."
  end
  
end

ActiveAdmin.register User do

  actions :all, :except => [:new]
  menu priority: 3
  batch_action :destroy do |selection|
    User.find(selection).each do |user|
      user.destroy
    end
    redirect_to admin_users_path, :alert => "Users has been deleted successfully."
  end
   
  filter :name
  filter :email
  filter :gender

  index do
    selectable_column
    column :email
    column :name
    column :gender
    column "Actions" do |video|  
      a do                                                         
        link_to 'View' , admin_user_path(video)
      end
      a do
        link_to 'Edit', edit_admin_user_path(video)   
      end  
      a do
        link_to 'Delete', admin_user_path(video), method: :delete, :data => { :confirm => 'Are you sure, you want to delete this user?' }
      end
    end
  end


  form do |f|
    f.inputs "User" do 
      f.input :name
      f.input :email#, :input_html => { :disabled => true } 
      f.input :gender, as: :radio, collection: ['Male','Female']
      f.input :age, as: :string
    end
    f.actions 
  end  


  show do |ad|
    attributes_table do
      row :name
      row :email
      row :age
      row :gender
    end
  end

  controller do
    def permitted_params
      params.permit user: [:email, :password, :password_confirmation, :name, :gender, :age]
    end
  end


end

ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation
  menu priority: 2
  index do
    selectable_column
    column :email
    column :created_at
    actions
  end

  filter :email


  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do |ad|
    attributes_table do
      row :email
      row :password
    end
  end

end

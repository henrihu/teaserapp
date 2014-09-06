ActiveAdmin.register Genre do

  filter :name

  batch_action :destroy do |selection|
    Genre.find(selection).each do |genre|
      user.destroy
    end
    redirect_to admin_genres_path, :alert => "Genres has been deleted successfully."
  end
  
  index do
    selectable_column
    column :name
    column "Created On", :created_at
    
    
    column "Actions" do |genre|  
      a do                                                         
        link_to 'View' , admin_genre_path(genre)
      end
      a do
        link_to 'Edit', edit_admin_genre_path(genre)   
      end  
      a do
        link_to 'Delete', admin_genre_path(genre), method: :delete, :data => { :confirm => 'Are you sure, you want to delete this genre?' }
      end
    end
  end
  
  show do |ad|
    attributes_table do
      row :name
    end
  end

  controller do
    def permitted_params
      params.permit genre: [:name]
    end
  end

end

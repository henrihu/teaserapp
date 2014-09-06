ActiveAdmin.register Video do

  batch_action :destroy do |selection|
    Video.find(selection).each do |video|
      video.destroy
    end
    redirect_to admin_videos_path, :alert => "Videos has been deleted successfully."
  end

  filter :name
  filter :genre


  form do |f|
    f.inputs "Video" do
      f.input :name
      f.input :genre_id, as: :select, :collection => Genre.all.map{ |genre| [genre.name, genre.id] }, :prompt => 'Select one'
      f.input :year, :as => :select, :collection => (1950..Time.now.year).to_a
      f.input :link
    end
    f.actions
  end
  
  index :download_links => false do
    selectable_column
    column :name
    column :genre
    column "Actions" do |video|  
      a do                                                         
        link_to 'View', admin_video_path(video)
      end
      a do
        link_to 'Edit', edit_admin_video_path(video)
      end
      a do
        link_to 'Delete', admin_video_path(video), method: :delete, :data => { :confirm => 'Are you sure, you want to delete this video?' }     
      end
    end
  end

  show do |ad|
    attributes_table do
      row :name
      row :genre
      row "Link" do
        link_to ad.link, ad.link, target: '_blank'  
      end  
      row :year
      row "Created On" do
        ad.created_at
      end
    end
  end


  controller do
    def permitted_params
      params.permit video: [:name, :year, :link, :genre_id]
    end
  end

end

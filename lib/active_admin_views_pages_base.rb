class ActiveAdmin::Views::Pages::Base < Arbre::HTML::Document

  private

  # Renders the content for the footer
  def build_footer
    div :id => "footer" do
      para "Copyright &copy; #{Date.today.year.to_s} #{link_to('Teaser App', 'http://www.teaser-app.com/',:target => '_blank')}. Powered by #{link_to('Mobiloitte', 'http://www.mobiloitte.com')} #{}".html_safe
    end
  end

end
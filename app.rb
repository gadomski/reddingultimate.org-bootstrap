# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.

module Nesta
  class App
    # Uncomment the Rack::Static line below if your theme has assets
    # (i.e images or JavaScript).
    #
    # Put your assets in themes/bootstrap/public/bootstrap.
    #
    use Rack::Static, :urls => ["/bootstrap"], :root => "themes/bootstrap/public"

    not_found do
      haml :error
    end

    helpers do
      def container
        if @page && @page.flagged_as?('fluid')
          'container-fluid'
        else
          'container'
        end
      end
    end

    def author_biography(name = nil)
      name ||= @page.metadata('author')
      if name
        short_name = name.downcase.gsub(/\W+/, '_').to_sym
        avatar_path = File.join(['images', 'authors', "#{short_name}.jpg"])
        html = ""
        locals = { :has_avatar => false }
        if File.exist?(File.join(Nesta::App.root, 'public', avatar_path))
          html += capture_haml do
            haml_tag :img, :src => "/#{avatar_path}", :class => 'avatar'
          end
          locals[:has_avatar] = true
        end
        html << haml(short_name.to_sym, :layout => false, :locals => locals)
      end
    end

  end
end

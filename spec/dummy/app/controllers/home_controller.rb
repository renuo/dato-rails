class HomeController  < ApplicationController
  def show
    client = Dato::Client.new
    response = client.execute!(homepage_query)
    @content = response.data.homepage.content
  end

  private

  def homepage_query
    GQLi::DSL.query {
      homepage {
        id
        _createdAt
        _seoMetaTags {
          attributes
          content
          tag
        }
        content {
          value
          blocks {
            id
            image {
              responsiveImage(imgixParams: {fm: __enum("png")}) {
                ___ Dato::Fragments::ResponsiveImage
              }
            }
          }
        }
      }
    }
  end
end
